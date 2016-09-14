//
//  Step.h
//  DrawerDemo
//
//  Created by paul on 16/9/14.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMResultSet;

@interface Step : NSObject
@property(assign,nonatomic)float position;
@property(assign,nonatomic)float velocity;
@property(assign,nonatomic)float time;
@property(assign,nonatomic)float delay;
@property(assign,nonatomic)int active;

- (instancetype)initWithFMResultSet:(FMResultSet *)rs;

@end
