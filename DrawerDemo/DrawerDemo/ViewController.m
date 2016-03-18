//
//  ViewController.m
//  DrawerDemo
//
//  Created by WangPeng on 16/3/18.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "LeftSubViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self.type isEqualToString:@"type"]) {
        [self performSegueWithIdentifier:@"subVC" sender:self];
    }
    [self setNaviagtionBar];
}

-(void)setNaviagtionBar
{
    UIBarButtonItem *leftitem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-mulu"] style:UIBarButtonItemStylePlain target:self action:@selector(openDrawerSide:)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
