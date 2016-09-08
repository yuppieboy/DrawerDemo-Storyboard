//
//  SVProgressHUD+Add.h
//  MSSForOffLine
//
//  Created by Paul on 16/7/1.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (Add)

+(void)showInfoWithStatus:(NSString *)status dismissAfterDelay:(NSTimeInterval)delay;
+(void)showSuccessWithStatus:(NSString *)status dismissAfterDelay:(NSTimeInterval)delay;
+(void)showErrorWithStatus:(NSString *)status dismissAfterDelay:(NSTimeInterval)delay;
+(void)showProgressWithStatus:(NSString *)status dismissAfterDelay:(NSTimeInterval)delay;

@end
