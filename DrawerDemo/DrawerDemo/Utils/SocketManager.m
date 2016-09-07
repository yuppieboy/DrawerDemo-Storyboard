//
//  SocketManager.m
//  DDG
//
//  Created by paul on 16/8/23.
//  Copyright © 2016年 paul. All rights reserved.
//

#import "SocketManager.h"

@interface SocketManager()

@end

@implementation SocketManager


+ (instancetype)shareManager
{
    static SocketManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SocketManager alloc]init];
    });
    return instance;
}

- (void)openSocket
{
    if ([self.asyncSocket isConnected]) {
        return;
    }
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self.delegate delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if (![self.asyncSocket connectToHost:self.model.hostName onPort:self.model.port error:&error])
    {
        NSLog(@"Unable to connect to due to invalid configuration: %@", error);
    }
    else
    {
        NSLog(@"Connecting to %@ on port %i...", self.model.hostName , self.model.port);
    }
    
}

- (void)closeSocket
{
    [self.asyncSocket disconnect];
}

@end
