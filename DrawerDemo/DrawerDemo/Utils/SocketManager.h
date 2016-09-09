//
//  SocketManager.h
//  DDG
//
//  Created by paul on 16/8/23.
//  Copyright © 2016年 paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SocketModel.h"

@interface SocketManager : NSObject
@property (nonatomic,strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic,strong) id<GCDAsyncSocketDelegate> delegate;
@property (nonatomic,strong) SocketModel *model;

@property (nonatomic,strong) NSArray *sendArray;    //input
@property (nonatomic,strong) NSMutableArray *values;//output

+ (instancetype)shareManager;
- (void)openSocket;
- (void)closeSocket;
- (void)sendMessage;


@end
