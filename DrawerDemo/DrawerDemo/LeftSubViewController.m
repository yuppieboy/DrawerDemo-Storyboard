//
//  LeftSubViewController.m
//  DrawerDemo
//
//  Created by WangPeng on 16/3/18.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "LeftSubViewController.h"

@implementation LeftSubViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

@end
