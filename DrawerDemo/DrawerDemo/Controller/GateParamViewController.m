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

typedef enum : NSUInteger {
    StepperStatus_Up,
    StepperStatus_Down,
} StepperStatus;

@interface GateParamViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, nonnull,strong) NSTimer *timer;

@property (strong, nonatomic) IBOutlet UIView *explainView;

@property (strong, nonatomic) IBOutlet UIView *PoPostionView;
@property (weak, nonatomic) IBOutlet UITextField *tf_poPosition;
@property (weak, nonatomic) IBOutlet UILabel *lb_originPoPostion;

@property (weak, nonatomic) IBOutlet UILabel *lb_cylinkerType;

@property (weak, nonatomic) IBOutlet UILabel *lb_screwLead;
@property (weak, nonatomic) IBOutlet UILabel *lb_pcPostiton;
@property (weak, nonatomic) IBOutlet UILabel *lb_poPostion;
@property (weak, nonatomic) IBOutlet UILabel *lb_strokeLength;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic,assign) int tiny;//0.01#0.1#1


@property (nonatomic,strong) Gate *gate;
@end

@implementation GateParamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentControl.selectedSegmentIndex = 0;
        
    [self.timer fire];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)initCylinkerType
{
    switch (self.gate.cylinkerType) {
        case CylinkerType_TSC80:
            self.lb_cylinkerType.text = @"TSC 80";
            self.lb_screwLead.text = @"4mm";

            break;
        case CylinkerType_TSC130:
            self.lb_cylinkerType.text = @"TSC 130";
            self.lb_screwLead.text = @"5mm";

            break;
        default:
            break;
    }

}

- (Gate *)gate
{
    _gate = [SocketManager shareManager].values[_selectIndex];
    return _gate;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadSubViewsData) userInfo:nil repeats:YES];
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
        return @"阀针微调(-2.00mm~+2.00mm)";
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
    }else if(indexPath.section == 1 && indexPath.row == 4)
    {
        [self showPositionView];
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
    self.lb_pcPostiton.text = [NSString stringWithFormat:@"%@ mm",self.gate.position];
    self.lb_strokeLength.text = [NSString stringWithFormat:@"%.2f mm",[self.gate.po_Postion floatValue]-[self.gate.position floatValue]];
    self.lb_poPostion.text = [NSString stringWithFormat:@"%@ mm",self.gate.po_Postion];
    [self initCylinkerType];
}

- (void)showPopListView
{
    PopListView *popView = [[NSBundle mainBundle]loadNibNamed:@"PopListView" owner:self options:nil].lastObject;
    popView.dataArray = @[@"TSC 80",@"TSC 130"];
    popView.didSelectCellBlock = ^(NSString *cylinkerType){
        if ([cylinkerType isEqualToString:@"TSC 80"]) {
            [self saveCylinkerType:CylinkerType_TSC80];
        }else if([cylinkerType isEqualToString:@"TSC 130"])
        {
            [self saveCylinkerType:CylinkerType_TSC130];
        }
        self.lb_cylinkerType.text = cylinkerType;

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

- (void)showPositionView
{
    self.lb_originPoPostion.text = self.lb_poPostion.text;
    self.PoPostionView.alpha = 0;
    [self.PoPostionView setFrame:CGRectMake(0, 0, TTScreenWidth, TTScreenHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        self.PoPostionView.alpha = 1;
        [[UIApplication sharedApplication].keyWindow.currentViewController.view addSubview:self.PoPostionView];
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

- (void)stepBtnClick:(StepperStatus)status
{
    NSString *command1;
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            self.tiny = 0.01;
            command1 = @"08 00 00 06 00 23 00 31 00 00 00 00 00";
            break;
        case 1:
            self.tiny = 0.1;
            command1 = @"08 00 00 06 00 23 00 31 00 01 00 00 00";
            break;
        case 2:
            self.tiny = 1;
            command1 = @"08 00 00 06 00 23 00 31 00 02 00 00 00";
            break;
            
        default:
            break;
    }
    
    NSString *command2 = @"08 00 00 06 00 2B 03 30 00 00 00 00 00";
    NSString *command3;
    switch (status) {
        case StepperStatus_Up:
            command3 = @"08 00 00 06 00 2B 03 30 00 01 00 00 00";
            break;
        case StepperStatus_Down:
            command3 = @"08 00 00 06 00 2B 03 30 00 02 00 00 00";
            break;
            
        default:
            break;
    }
    
    
    NSString *num;
    if (_selectIndex<15) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }
    command1 = [command1 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    command2 = [command2 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    command3 = [command3 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    
    [SocketManager shareManager].sendArray = @[@[command1,command2,command3]];
    [[SocketManager shareManager] sendMessage];

}

- (void)saveCylinkerType:(CylinkerType)type
{
    [SVProgressHUD showProgressWithStatus:@"正在设置机电类型..." dismissAfterDelay:1];
    
    NSString *command;

    switch (type) {
        case CylinkerType_TSC80:
            command = @"08 00 00 06 00 2B 02 64 00 00 00 00 00";
            break;
        case CylinkerType_TSC130:
            command = @"08 00 00 06 00 2B 02 64 00 01 00 00 00";
            break;
   
        default:
            break;
    }
        NSString *num;
    if (_selectIndex<15) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:(int)_selectIndex+1]];
    }
    command = [command stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    
    [SocketManager shareManager].sendArray = @[@[command]];
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
- (IBAction)closePoPostionView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.PoPostionView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.PoPostionView removeFromSuperview];
    }];
}

- (IBAction)stepOnClick:(id)sender {
    NSLog(@"+");
    [SVProgressHUD showProgressWithStatus:@"微调中..." dismissAfterDelay:1];
    [self stepBtnClick:StepperStatus_Up];
    
}

- (IBAction)stepOffClick:(id)sender {
    NSLog(@"-");
    [SVProgressHUD showProgressWithStatus:@"微调中..." dismissAfterDelay:1];
    [self stepBtnClick:StepperStatus_Down];
}

- (IBAction)saveOriginPosition:(id)sender {
    
    [SVProgressHUD showProgressWithStatus:@"保存原点..." dismissAfterDelay:1];
    
    NSString *command1 = @"08 00 00 06 00 2B 05 30 00 00 00 00 00";
    NSString *command2 = @"08 00 00 06 00 2B 05 30 00 01 00 00 00";

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
        [self modifyPoPostionWithNumber:[textField.text floatValue]*100];
    }
}

@end
