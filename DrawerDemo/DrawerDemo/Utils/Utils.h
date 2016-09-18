//
//  Utils.h
//  DrawerDemo
//
//  Created by paul on 16/9/1.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIButton+Add.h"
#import "DataBaseManager.h"
#import "Gate.h"

@interface Utils : NSObject

+ (UIViewController *)getVCFromSBName:(NSString *)sbName vcClass:(Class)vcClass;
+ (NSString *)convertDataToHexStr:(NSData *)data;
+ (NSData *)convertHexStrToData:(NSString *)hexStr;
+ (NSString *)exchangeByteString:(NSString *)string;
+ (NSString *)convertHexStrToDecimalism:(NSString *)hexStr;
+ (NSString *)convertDecimalismToHexStr:(int)decimalism;
+ (NSString *)getPath;
@end
