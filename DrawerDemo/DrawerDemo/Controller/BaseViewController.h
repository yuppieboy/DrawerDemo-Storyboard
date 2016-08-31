//
//  BaseViewController.h
//  DrawerDemo
//
//  Created by paul on 16/8/9.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseVCDelegate <NSObject>

@optional

-(void)updateData;

@end

@interface BaseViewController : UIViewController

@property(nonatomic,strong)id <BaseVCDelegate> delegate;

@end
