//
//  AutoViewController.h
//  DrawerDemo
//
//  Created by paul on 16/8/9.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AutoCell;

@protocol AutoCellDelegate <NSObject>

@optional

- (void)powerBtnDidTap:(NSInteger)section inCell:(AutoCell *)cell;

@end

@interface AutoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_position;
@property (weak, nonatomic) IBOutlet UILabel *lb_dforce;
@property (weak, nonatomic) IBOutlet UILabel *lb_ctime;
@property (weak, nonatomic) IBOutlet UILabel *lb_otime;
@property (weak, nonatomic) IBOutlet UIImageView *pinImg;
@property (nonatomic,strong) id <AutoCellDelegate> delegate;

@end

@interface AutoViewController : BaseViewController

@end
