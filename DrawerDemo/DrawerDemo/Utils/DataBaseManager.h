//
//  DataBaseManager.h
//  DrawerDemo
//
//  Created by paul on 16/9/14.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "Step.h"

@interface DataBaseManager : NSObject
@property(nonatomic,strong)FMDatabase *db;
+ (DataBaseManager *)sharedManager;
- (NSArray *)getStepsFromGateIndex:(int)index;
- (BOOL)updateStepFromGateIndex:(int)index withStep:(Step *)step AndStepId:(int)stepId;
- (BOOL)updateStepActiveFromGateIndex:(int)index withLastStepId:(int)stepId;
- (BOOL)updateStepInActiveFromGateIndex:(int)index withFirstStepId:(int)stepId;
- (BOOL)updatePoPositionFromGateIndex:(int)index WithPoPosition:(NSString *)poposition;

@end
