//
//  GateSettingViewController.m
//  DrawerDemo
//
//  Created by paul on 16/9/1.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "GateSettingViewController.h"
#import "IQUIWindow+Hierarchy.h"

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
@end

@implementation GateSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.setNumView setFrame:CGRectMake(0, 0, TTScreenWidth, 80)];
    self.tableView.tableFooterView = self.setNumView;
    
}

#pragma mark - Actions

- (IBAction)saveSteps:(id)sender {
    [self.tf_stepsNum resignFirstResponder];
    if ([self.tf_stepsNum.text intValue] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先设置步骤" dismissAfterDelay:1];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"保存成功" dismissAfterDelay:1];
    }
}
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
    }else
    {
        cell.lb_stepNum.text = [NSString stringWithFormat:@"Step%li",(long)indexPath.row];
    }
    cell.lb_position.text = @"0";
    cell.lb_velocity.text = @"0";
    cell.lb_time.text = @"0";
    cell.lb_delay.text = @"0";
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
