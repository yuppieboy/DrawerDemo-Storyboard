//
//  Gate.h
//  DrawerDemo
//
//  Created by paul on 16/9/1.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PinStatus_Close,
    PinStatus_Open,
    PinStatus_Middle,
} PinStatus;

typedef enum : NSUInteger {
    GateStatus_Close,
    GateStatus_Open,
} GateStatus;

typedef enum : NSUInteger {
    CylinkerType_TSC80,
    CylinkerType_TSC130,
} CylinkerType;


@interface Gate : NSObject
@property (nonatomic,assign)GateStatus gateSatus;
@property (nonatomic,assign)PinStatus pinStatus;
@property (nonatomic,assign)CylinkerType cylinkerType;

@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *dForce;
@property (nonatomic,strong)NSString *cTime;
@property (nonatomic,strong)NSString *oTime;
@property (nonatomic,strong)NSString *po_Postion;

@end
