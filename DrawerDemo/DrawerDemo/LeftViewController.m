//
//  LeftViewController.m
//  DrawerDemo
//
//  Created by WangPeng on 16/3/18.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "LeftViewController.h"
#import "ViewController.h"

@implementation LeftViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)btnClick:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController * centerSideNavController =
    [storyboard instantiateViewControllerWithIdentifier:
     @"ViewController"];
    centerSideNavController.type=@"type";
    
    UINavigationController * nav = [[UINavigationController alloc]
                                                     initWithRootViewController:centerSideNavController];
    
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];

}
@end
