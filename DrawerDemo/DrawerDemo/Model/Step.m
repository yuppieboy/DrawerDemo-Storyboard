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
        self.position  = [rs intForColumn:@"position"];
        self.time  = [rs intForColumn:@"runtime"];
        self.velocity  = [rs intForColumn:@"velocity"];
        self.delay  = [rs intForColumn:@"delay"];
        self.active  = [rs intForColumn:@"active"];
    }
    return self;
}

@end
