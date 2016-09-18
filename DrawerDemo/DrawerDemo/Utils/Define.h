//
//  Define.h
//  MSSForOffLine
//
//  Created by Paul on 16/6/21.
//  Copyright © 2016年 Paul. All rights reserved.
//

#ifndef Define_h
#define Define_h

@import Foundation;

#define KeyWindow   ([UIApplication sharedApplication].keyWindow)

#define kMainScreenScale ([UIScreen mainScreen].scale)

#define WEAKSELF  typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define TTScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define TTScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define TTOnePix    (1.f / [UIScreen mainScreen].scale)

#define Ratio TTScreenWidth/414

#define iOS7 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)

#define iOS8 ([UIVisualEffectView class] != Nil)

#define TTDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//#define RGBCOLORHEX(rgb) [UIColor colorWithRed:((rgb) & 0xFF0000 >> 16) / 255.0 green:((rgb) & 0xFF00 >> 8) / 255.0 blue:((rgb) & 0xFF) / 255.0 alpha:1.0]

#define RGBCOLORHEX(rgb)    [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]


#define USERINFOADD(x, y) [[NSUserDefaults standardUserDefaults] setObject:x forKey:y], [[NSUserDefaults standardUserDefaults] synchronize]
#define USERINFOFIND(x) [[NSUserDefaults standardUserDefaults] objectForKey:x]
#define USERINFOREMOVE(x) [[NSUserDefaults standardUserDefaults] removeObjectForKey:x]

#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Language"]

#define DarkBlack RGBCOLORHEX(0x1A2228)
#define LightBlack RGBCOLORHEX(0x22292F)

static NSString *const kNotification_updateLanguage =@"kNotification_updateLanguage";
static NSString *const kNotification_Login =@"kNotification_Login";

#define dbPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/servo.db"]

#endif /* Define_h */
