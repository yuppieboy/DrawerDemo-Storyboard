//
//  EnlargeEdgeButton.m
//  DrawerDemo
//
//  Created by paul on 16/9/14.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "EnlargeEdgeButton.h"
#import "UIButton+Add.h"

@implementation EnlargeEdgeButton

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self setEnlargeEdge:30];
}

@end
