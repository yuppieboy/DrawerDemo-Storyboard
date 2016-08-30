//
//  AutoViewController.h
//  DrawerDemo
//
//  Created by paul on 16/8/9.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_position;
@property (weak, nonatomic) IBOutlet UILabel *lb_dforce;
@property (weak, nonatomic) IBOutlet UILabel *lb_ctime;
@property (weak, nonatomic) IBOutlet UILabel *lb_otime;
@property (weak, nonatomic) IBOutlet UIImageView *signalImg;
@property(nonatomic,strong)void (^powerBtnClick)();
@end

@interface AutoViewController : BaseViewController

@end
