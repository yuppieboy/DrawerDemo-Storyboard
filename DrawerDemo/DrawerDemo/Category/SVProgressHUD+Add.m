//
//  SVProgressHUD+Add.m
//  MSSForOffLine
//
//  Created by Paul on 16/7/1.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SVProgressHUD+Add.h"

@implementation SVProgressHUD (Add)


+(void)showInfoWithStatus:(NSString *)status dismissAfterDelay:(NSTimeInterval)delay
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showInfoWithStatus:status];
    [self performSelector:@selector(dismiss) withObject:self afterDelay:delay];

}

+ (void)showSuccessWithStatus:(NSString *)status dismissAfterDelay:(NSTimeInterval)delay
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:status];
    [self performSelector:@selector(dismiss) withObject:self afterDelay:delay];
    
}

+ (void)showErrorWithStatus:(NSString *)status dismissAfterDelay:(NSTimeInterval)delay
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showErrorWithStatus:status];
    [self performSelector:@selector(dismiss) withObject:self afterDelay:delay];
}

+ (void)showProgressWithStatus:(NSString *)status dismissAfterDelay:(NSTimeInterval)delay
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:status];
    [self performSelector:@selector(dismiss) withObject:self afterDelay:delay];
}

@end
