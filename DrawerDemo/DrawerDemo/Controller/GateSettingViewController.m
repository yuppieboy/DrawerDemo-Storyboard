//
//  GateSettingViewController.m
//  DrawerDemo
//
//  Created by paul on 16/9/1.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "GateSettingViewController.h"
#import "IQUIWindow+Hierarchy.h"
#import "Step.h"
#import "Gate.h"

@interface stepCell()
@property (weak, nonatomic) IBOutlet UILabel *lb_stepNum;
@property (weak, nonatomic) IBOutlet UILabel *lb_position;
@property (weak, nonatomic) IBOutlet UILabel *lb_velocity;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_delay;

@end

@implementation stepCell

@end

@interface GateSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *setNumView;
@property (weak, nonatomic) IBOutlet UITextField *tf_stepsNum;
@property (nonatomic,assign) NSInteger selectedStepIndex;

@property (strong, nonatomic) IBOutlet UIView *stepsDetailsView;
@property (weak, nonatomic) IBOutlet UITextField *tf_position;
@property (weak, nonatomic) IBOutlet UITextField *tf_velocity;
@property (weak, nonatomic) IBOutlet UITextField *tf_time;
@property (weak, nonatomic) IBOutlet UITextField *tf_delay;

@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation GateSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.setNumView setFrame:CGRectMake(0, 0, TTScreenWidth, 40)];
    self.tableView.tableFooterView = self.setNumView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self fetchDataFromDB];
    self.tf_stepsNum.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count];
    [self.tableView reloadData];
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


- (void)fetchDataFromDB
{
    self.dataArray = [[DataBaseManager sharedManager]getStepsFromGateIndex:(int)self.selectIndex+1];
}

/**
 *  @brief 把1～12中某个位置保存到设备中
 *
 *  @param step 某一步的数据源
 */
- (void)saveStepToMachine:(Step *)step
{
    NSMutableString *command1 = [[NSMutableString alloc]initWithString:@"08 00 00 06 00 23 20 31 01 00 00 00 00"];//位置
    NSMutableString *command2 = [[NSMutableString alloc]initWithString:@"08 00 00 06 00 2B 20 31 02 00 00 00 00"];//运行时间
    NSMutableString *command3 = [[NSMutableString alloc]initWithString:@"08 00 00 06 00 2B 20 31 03 00 00 00 00"];//延迟时间

    NSString *num;
    if (_selectIndex<15) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }

    [command1 replaceCharactersInRange:NSMakeRange(12, 2) withString:num];
    [command2 replaceCharactersInRange:NSMakeRange(12, 2) withString:num];
    [command3 replaceCharactersInRange:NSMakeRange(12, 2) withString:num];
    
    //3120 3121 ..
    NSString *temp = [Utils convertDecimalismToHexStr:31+(int)self.selectedStepIndex];
    [command1 replaceCharactersInRange:NSMakeRange(18, 2) withString:temp];
    [command2 replaceCharactersInRange:NSMakeRange(18, 2) withString:temp];
    [command3 replaceCharactersInRange:NSMakeRange(18, 2) withString:temp];

    [command1 replaceCharactersInRange:NSMakeRange(27, 11) withString:[Utils makeupFourByteAndExchangeByteWithDecimalism:step.position*100]];
    [command2 replaceCharactersInRange:NSMakeRange(27, 11) withString:[Utils makeupFourByteAndExchangeByteWithDecimalism:step.time*100]];
    [command3 replaceCharactersInRange:NSMakeRange(27, 11) withString:[Utils makeupFourByteAndExchangeByteWithDecimalism:step.delay*100]];
    
    [SocketManager shareManager].sendArray = @[@[command1,command2,command3]];
    [[SocketManager shareManager] sendMessage];

}

#pragma mark - Actions

- (IBAction)closeStepsDetailsView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.stepsDetailsView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.stepsDetailsView removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tf_stepsNum.text intValue]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    stepCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([stepCell class]) forIndexPath:indexPath];
    if (indexPath.row == 0) {
        Gate *gate = [SocketManager shareManager].values[_selectIndex];
        cell.lb_stepNum.text = @"Start";
        cell.lb_position.text = gate.position;
        cell.lb_velocity.text = @"0";
        cell.lb_time.text = @"0";
        cell.lb_delay.text = @"0";
        
    }else
    {
        cell.lb_stepNum.text = [NSString stringWithFormat:@"Step%li",(long)indexPath.row];
        Step *step = self.dataArray[indexPath.row-1];
        cell.lb_position.text = [NSString stringWithFormat:@"%.2f",step.position];
        cell.lb_velocity.text = [NSString stringWithFormat:@"%.2f",step.velocity];
        cell.lb_time.text = [NSString stringWithFormat:@"%.2f",step.time];
        cell.lb_delay.text = [NSString stringWithFormat:@"%.2f",step.delay];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>0) {
        self.selectedStepIndex = indexPath.row;
        Step *step = self.dataArray[indexPath.row-1];
        [self showStepsDetailViewWithStep:step];
    }
    
}

- (void)showStepsDetailViewWithStep:(Step *)step
{
    self.stepsDetailsView.alpha = 0;
    [self.stepsDetailsView setFrame:CGRectMake(0, 0, TTScreenWidth, TTScreenHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        self.stepsDetailsView.alpha = 1;
        [[UIApplication sharedApplication].keyWindow.currentViewController.view addSubview:self.stepsDetailsView];
    } completion:^(BOOL finish){
        self.tf_position.text = [NSString stringWithFormat:@"%.2f",step.position];
        self.tf_velocity.text = [NSString stringWithFormat:@"%.2f",step.velocity];
        self.tf_time.text = [NSString stringWithFormat:@"%.2f",step.time];
        self.tf_delay.text = [NSString stringWithFormat:@"%.2f",step.delay];
    }];

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.tf_stepsNum) {
        if ([self.tf_stepsNum.text intValue]>12) {
            self.tf_stepsNum.text = @"12";
        }
        if ([[DataBaseManager sharedManager]updateStepActiveFromGateIndex:(int)self.selectIndex+1 withLastStepId:[self.tf_stepsNum.text intValue]]&&[[DataBaseManager sharedManager] updateStepInActiveFromGateIndex:(int)self.selectIndex+1 withFirstStepId:[self.tf_stepsNum.text intValue]+1]) {
            [self fetchDataFromDB];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showSuccessWithStatus:@"更新失败" dismissAfterDelay:1];
        }
        
    }else
    {
        textField.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
        if (textField == self.tf_time || textField == self.tf_position) {
            if ([self.tf_position.text floatValue]>0 && [self.tf_time.text floatValue]>0) {
                self.tf_velocity.text = [NSString stringWithFormat:@"%.2f",[self.tf_position.text floatValue]/[self.tf_time.text floatValue]];
            }
        }

    }
    
}


- (IBAction)confirmUpdateStep:(id)sender {
    if (self.tf_position.text.length&&self.tf_velocity.text.length&&self.tf_time.text.length&&self.tf_delay.text.length) {
        Step *step = [[Step alloc]init];
        step.position = [self.tf_position.text floatValue];
        step.velocity = [self.tf_velocity.text floatValue];
        step.time = [self.tf_time.text floatValue];
        step.delay = [self.tf_delay.text floatValue];
        step.active = 1;
        if ([[DataBaseManager sharedManager]updateStepFromGateIndex:(int)self.selectIndex+1 withStep:step     AndStepId:(int)self.selectedStepIndex]) {
            [self closeStepsDetailsView:self];
            [self fetchDataFromDB];
            [self.tableView reloadData];
            
            [self saveStepToMachine:step];

        }else
        {
            [SVProgressHUD showSuccessWithStatus:@"更新失败" dismissAfterDelay:1];

        }
        
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"请填写完整" dismissAfterDelay:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
