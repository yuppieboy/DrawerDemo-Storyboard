//
//  GateParamViewController.m
//  DrawerDemo
//
//  Created by paul on 16/9/8.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "GateParamViewController.h"
#import "PopListView.h"

@interface GateParamViewController()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *explainView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UILabel *cylinkerType;
@end

@implementation GateParamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.closeBtn setEnlargeEdge:30];
}

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
        [[UIApplication sharedApplication].keyWindow addSubview:self.explainView];
    } completion:nil];
   
}

- (IBAction)closeExplainView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.explainView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.explainView removeFromSuperview];
    }];
}

@end
