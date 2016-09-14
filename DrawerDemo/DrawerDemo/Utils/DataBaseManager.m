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

- (NSArray *)getStepsFromGateIndex:(int)index
{
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[Utils dbPath]];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from steps where gate_id = %i and active = 1",index];
        FMResultSet *rs=[db executeQuery:sql];
        while ([rs next]) {
            Step *item=[[Step alloc]initWithFMResultSet:rs];
            [temp addObject:item];
        }
        
    }
    return temp;
}


@end
