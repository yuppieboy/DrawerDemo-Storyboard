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

@property (strong, nonatomic) IBOutlet UIView *stepsDetailsView;

@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation GateSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.setNumView setFrame:CGRectMake(0, 0, TTScreenWidth, 40)];
    self.tableView.tableFooterView = self.setNumView;
    
//    NSArray *array = [NSArray arrayWithArray:[[DataBaseManager sharedManager]getStepsFromGateIndex:1]];
//    for (int i = 0; i< array.count; i++ ) {
//        Step *step = array[i];
//        NSLog(@"%f,%f,%f,%f,%i",step.position,step.velocity,step.time,step.delay,step.active);
//    }
    self.dataArray = [[DataBaseManager sharedManager]getStepsFromGateIndex:(int)self.selectIndex+1];
    self.tf_stepsNum.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count];
}


- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
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
        cell.lb_stepNum.text = @"Start";
        cell.lb_position.text = @"0";
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
        [self showStepsDetailView];
    }
    
}

- (void)showStepsDetailView
{
    self.stepsDetailsView.alpha = 0;
    [self.stepsDetailsView setFrame:CGRectMake(0, 0, TTScreenWidth, TTScreenHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        self.stepsDetailsView.alpha = 1;
        [[UIApplication sharedApplication].keyWindow.currentViewController.view addSubview:self.stepsDetailsView];
    } completion:nil];

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.tf_stepsNum) {
        if ([self.tf_stepsNum.text intValue]>12) {
            self.tf_stepsNum.text = @"12";
        }
        [self.tableView reloadData];
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
