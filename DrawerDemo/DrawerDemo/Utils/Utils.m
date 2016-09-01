//
//  Utils.m
//  DrawerDemo
//
//  Created by paul on 16/9/1.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIViewController *)getVCFromSBName:(NSString *)sbName vcClass:(Class)vcClass
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    id vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(vcClass)];
    
    return vc;
}

@end
