//
//  AutoViewController.h
//  DrawerDemo
//
//  Created by paul on 16/8/9.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoCell : UITableViewCell

@end

@interface AutoStatusCell : UITableViewCell
@property(nonatomic,strong)void (^powerBtnClick)(NSInteger tag);
@end

@interface AutoViewController : BaseViewController

@end