//
//  BaseViewController.m
//  DrawerDemo
//
//  Created by paul on 16/8/9.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_updateLanguage object:nil];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviagtionBar];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:kNotification_updateLanguage object:nil];

}


-(void)setNaviagtionBar
{
    UIBarButtonItem *leftitem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-mulu"] style:UIBarButtonItemStylePlain target:self action:@selector(openDrawerSide:)];
    [leftitem setTintColor:RGBCOLORHEX(0x22292F)];
    self.navigationItem.leftBarButtonItem=leftitem;
}

-(void)openDrawerSide:(id)sender;
{
    if ([self.mm_drawerController openSide]==MMDrawerSideNone) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }else
    {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
}

-(void)updateData
{
    //updateData
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
