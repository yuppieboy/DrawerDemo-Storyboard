//
//  DataBaseManager.h
//  DrawerDemo
//
//  Created by paul on 16/9/14.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DataBaseManager : NSObject
@property(nonatomic,strong)FMDatabase *db;
+ (DataBaseManager *)sharedManager;
- (NSArray *)getStepsFromGateIndex:(int)index;
@end
