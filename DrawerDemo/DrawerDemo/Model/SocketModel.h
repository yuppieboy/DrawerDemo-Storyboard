//
//  SocketModel.h
//  DrawerDemo
//
//  Created by paul on 16/9/6.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketModel : NSObject
@property(nonatomic,strong)NSString *hostName;
@property(nonatomic,assign)int port;
@property(nonatomic,assign)int linkNum;

@end
