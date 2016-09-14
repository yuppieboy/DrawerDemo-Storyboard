//
//  Utils.m
//  DrawerDemo
//
//  Created by paul on 16/9/1.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIViewController *)getVCFromSBName:(NSString *)sbName vcClass:(Class)vcClass
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    id vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(vcClass)];
    
    return vc;
}


#pragma mark - Format Convert


+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


+ (NSData *)convertHexStrToData:(NSString *)hexStr
{
    NSMutableArray *dateArr = [NSMutableArray arrayWithArray:[hexStr componentsSeparatedByString:@" "]];
    
    Byte bytes[dateArr.count];
    
    for (int i = 0; i<dateArr.count; i++) {
        
        NSString * temp = [NSString stringWithFormat:@"%lu",strtoul([dateArr[i] UTF8String],0,16)];
        [dateArr replaceObjectAtIndex:i withObject:temp];
        bytes[i] = [temp integerValue];
        
    }
    NSData *data = [NSData dataWithBytes:bytes length:dateArr.count];
    return data;
}

+ (NSString *)exchangeByteString:(NSString *)string
{
    NSString *temp1 = [string substringWithRange:NSMakeRange(0, 2)];
    NSString *temp2 = [string substringWithRange:NSMakeRange(2, 2)];
    NSString *temp3 = [string substringWithRange:NSMakeRange(4, 2)];
    NSString *temp4 = [string substringWithRange:NSMakeRange(6, 2)];
    NSString *rs = [NSString stringWithFormat:@"%@%@%@%@",temp4,temp3,temp2,temp1];
    return rs;
}


+ (NSString *)convertHexStrToDecimalism:(NSString *)hexStr
{
    NSString * temp = [NSString stringWithFormat:@"%lu",strtoul([hexStr UTF8String],0,16)];
    return temp;
}

+ (NSString *)convertDecimalismToHexStr:(int)decimalism
{
    NSString *temp = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",decimalism]];
    return temp;
}

+ (NSString *)dbPath
{
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"servo" ofType:@"db"];
    return dbPath;
}

@end
