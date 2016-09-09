//
//  GateParamViewController.m
//  DrawerDemo
//
//  Created by paul on 16/9/8.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "GateParamViewController.h"
#import "PopListView.h"
#import "IQUIWindow+Hierarchy.h"
#import "Gate.h"

@interface GateParamViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *explainView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *cylinkerType;
@property (nonatomic, nonnull,strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UITextField *tf_pcPostiton;
@property (weak, nonatomic) IBOutlet UITextField *tf_poPosition;

@property (nonatomic,strong) Gate *gate;
@end

@implementation GateParamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.closeBtn setEnlargeEdge:30];
    
    [self.timer fire];
    
    self.tf_poPosition.text = [NSString stringWithFormat:@"%@ mm",self.gate.po_Postion];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (Gate *)gate
{
    _gate = [SocketManager shareManager].values[_selectIndex];
    return _gate;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(reloadSubViewsData) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"阀针类型";
    }else if(section == 1)
    {
        return @"阀针微调(-2mm~+2mm)";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select section = %li  row = %li",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showExplainView];
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        [self showPopListView];
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        [SVProgressHUD showProgressWithStatus:@"正在回起点..." dismissAfterDelay:1];
        [self backToOrigin];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return CGFLOAT_MIN;
}

#pragma mark - Private Method

- (void)reloadSubViewsData
{
    self.tf_pcPostiton.text = [NSString stringWithFormat:@"%@ mm",self.gate.position];
}

- (void)showPopListView
{
    PopListView *popView = [[NSBundle mainBundle]loadNibNamed:@"PopListView" owner:self options:nil].lastObject;
    popView.dataArray = @[@"TSC 80",@"TSC 130"];
    popView.didSelectCellBlock = ^(NSString *cylinkerType){
        self.cylinkerType.text = cylinkerType;
    };
    popView.alpha = 0;
    [popView setFrame:CGRectMake(0, 0, TTScreenWidth, TTScreenHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        popView.alpha = 1;
        [[UIApplication sharedApplication].keyWindow addSubview:popView];
    } completion:nil];

}

- (void)showExplainView
{
    self.explainView.alpha = 0;
    [self.explainView setFrame:CGRectMake(0, 0, TTScreenWidth, TTScreenHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        self.explainView.alpha = 1;
        [[UIApplication sharedApplication].keyWindow.currentViewController.view addSubview:self.explainView];
    } completion:nil];
   
}

- (void)modifyPoPostionWithNumber:(int)number
{
    NSString *hexString = [Utils convertDecimalismToHexStr:number];
    if (hexString.length<8) {
        for (int i = 0; i < hexString.length-8; i++) {
            hexString  = [NSString stringWithFormat:@"0%@",hexString];
        }
    }
    hexString = [Utils exchangeByteString:hexString];
    
    NSMutableString *command1 = [[NSMutableString alloc]initWithString:@"08 00 00 06 00 23 20 31 01 00 00 00 00"];
    
    [command1 replaceCharactersInRange:NSMakeRange(27, 2) withString:[hexString substringWithRange:NSMakeRange(0, 2)]];
    [command1 replaceCharactersInRange:NSMakeRange(30, 2) withString:[hexString substringWithRange:NSMakeRange(2, 2)]];
    [command1 replaceCharactersInRange:NSMakeRange(33, 2) withString:[hexString substringWithRange:NSMakeRange(4, 2)]];
    [command1 replaceCharactersInRange:NSMakeRange(36, 2) withString:[hexString substringWithRange:NSMakeRange(6, 2)]];
    
    NSString *num;
    if (_selectIndex<15) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }

    [command1 replaceCharactersInRange:NSMakeRange(12, 2) withString:num];
    
    [SocketManager shareManager].sendArray = @[@[command1]];
    [[SocketManager shareManager] sendMessage];
    
}

- (void)backToOrigin
{
    NSString *command1 = @"08 00 00 06 00 2B 06 30 00 00 00 00 00";
    NSString *command2 = @"08 00 00 06 00 2B 06 30 00 01 00 00 00";
    NSString *num;
    if (_selectIndex<15) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }
    command1 = [command1 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    command2 = [command2 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    
    [SocketManager shareManager].sendArray = @[@[command1,command2]];
    [[SocketManager shareManager] sendMessage];


}



#pragma mark - Actions

- (IBAction)closeExplainView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.explainView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.explainView removeFromSuperview];
    }];
}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.tf_poPosition) {
        if ([textField.text floatValue] >= 20) {
            self.tf_poPosition.text = @"20.00 mm";
        }else
        {
            self.tf_poPosition.text = [NSString stringWithFormat:@"%.2f mm",[textField.text floatValue]];
        }
        [self modifyPoPostionWithNumber:[self.tf_poPosition.text floatValue]*100];
    }
}

@end
