//
//  PopListView.h
//  DrawerDemo
//
//  Created by paul on 16/9/8.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopListView : UIView
@property (nonatomic,strong)NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) void (^didSelectCellBlock)(NSString *value);
@end
