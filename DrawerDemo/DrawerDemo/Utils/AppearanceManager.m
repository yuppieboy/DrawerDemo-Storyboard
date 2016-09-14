//
//  AppearanceManager.m
//  DrawerDemo
//
//  Created by paul on 16/9/8.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "AppearanceManager.h"

@implementation AppearanceManager

+ (void)config
{
    UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
    UIImage *backButtonImage = [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [barButtonAppearance setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [barButtonAppearance setTintColor:[UIColor blackColor]];
    
    UINavigationBar *navigationAppearance = [UINavigationBar appearance];
    [navigationAppearance setBackgroundColor:[UIColor whiteColor]];
    [navigationAppearance setBarTintColor:[UIColor whiteColor]];
    
}
@end
