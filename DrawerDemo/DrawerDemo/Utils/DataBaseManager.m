//
//  DataBaseManager.m
//  DrawerDemo
//
//  Created by paul on 16/9/14.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "DataBaseManager.h"
#import "Step.h"

@implementation DataBaseManager

+ (DataBaseManager *)sharedManager
{
    static DataBaseManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
    
}

/**
 *  @brief 获取某个阀针所有步骤
 *
 *  @param index 阀针下标
 *
 *  @return 某个阀针所有步骤
 */
- (NSArray *)getStepsFromGateIndex:(int)index
{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from steps where gate_id = %i and active = 1",index];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Step *item = [[Step alloc]initWithFMResultSet:rs];
            [temp addObject:item];
        }
        
    }
    return temp;
}


/**
 *  @brief 更新某个阀针的某一步骤
 *
 *  @param index  阀针下标
 *  @param step   某步的数据源
 *  @param stepId 第几步
 *
 *  @return 是否更新成功
 */
- (BOOL)updateStepFromGateIndex:(int)index withStep:(Step *)step AndStepId:(int)stepId
{
    BOOL rs = NO;
    FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"update steps set position = %f,runtime = %f,delay = %f,velocity = %f,active = 1 where gate_id = %i and step_id = %i",step.position,step.time,step.delay,step.velocity,index,stepId];
        rs = [db executeUpdate:sql];

    }
    return rs;

}

/**
 *  @brief 更新某个阀针的第n步之前的active，设为1
 *
 *  @param index  阀针下标
 *  @param stepId 第n步
 *
 *  @return 是否更新成功
 */
- (BOOL)updateStepActiveFromGateIndex:(int)index withLastStepId:(int)stepId
{
    BOOL rs = NO;
    FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"update steps set active = 1 where gate_id = %i and step_id <= %i",index,stepId];
        rs = [db executeUpdate:sql];
        
    }
    return rs;

}

/**
 *  @brief 更新某个阀针的第n步之前的active，设为0,并把数据清零
 *
 *  @param index  阀针下标
 *  @param stepId 第n步
 *
 *  @return 是否更新成功
 */
- (BOOL)updateStepInActiveFromGateIndex:(int)index withFirstStepId:(int)stepId
{
    BOOL rs = NO;
    FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"update steps set position = 0,runtime = 0,delay = 0,velocity = 0,active = 0 where gate_id = %i and step_id >= %i",index,stepId];
        rs = [db executeUpdate:sql];
        
    }
    return rs;

}


@end
