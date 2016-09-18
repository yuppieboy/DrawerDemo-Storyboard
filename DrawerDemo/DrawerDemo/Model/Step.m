//
//  Step.m
//  DrawerDemo
//
//  Created by paul on 16/9/14.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "Step.h"

@implementation Step

- (instancetype)initWithFMResultSet:(FMResultSet *)rs
{
    if (self = [super init]) {
        self.position  = [[rs stringForColumn:@"position"]floatValue];
        self.time  = [[rs stringForColumn:@"runtime"] floatValue];
        self.velocity  = [[rs stringForColumn:@"velocity"] floatValue];
        self.delay  = [[rs stringForColumn:@"delay"] floatValue];
        self.active  = [[rs stringForColumn:@"active"] floatValue];
    }
    return self;
}

@end
