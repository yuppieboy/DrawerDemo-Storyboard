//
//  PopListView.m
//  DrawerDemo
//
//  Created by paul on 16/9/8.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "PopListView.h"

@interface PopListView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_tableViewHeight;
@end

@implementation PopListView

- (void)awakeFromNib
{
    [self.closeBtn setEnlargeEdge:30];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setRowHeight:44];
    
}

- (void)layoutSubviews
{
    self.LayoutConstraint_tableViewHeight.constant = self.dataArray.count*self.tableView.rowHeight;
    [self layoutIfNeeded];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(self.dataArray[indexPath.row]);
    }
    [self closeBtnClick:self];
}


- (IBAction)closeBtnClick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];}
@end
