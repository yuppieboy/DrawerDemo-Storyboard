//
//  UITextField+Add.m
//  DrawerDemo
//
//  Created by paul on 16/8/10.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "UITextField+Add.h"
#import <objc/runtime.h>

static const void *dimensionKey = &dimensionKey;


@implementation UITextField (Add)
@dynamic dimension;

-(Dimension *)dimension
{
    return objc_getAssociatedObject(self, dimensionKey);
}

-(void)setDimension:(Dimension *)dimension
{
    objc_setAssociatedObject(self, dimensionKey, dimension, OBJC_ASSOCIATION_RETAIN);
}

@end
