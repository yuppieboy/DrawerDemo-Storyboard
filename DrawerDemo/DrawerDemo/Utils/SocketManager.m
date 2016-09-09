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

- (NSMutableArray *)values
{
    if (!_values) {
        _values = [NSMutableArray array];
    }
    return _values;
}

- (NSArray *)sendArray
{
    if (!_sendArray) {
        _sendArray = [NSArray array];
    }
    return _sendArray;
}



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

- (void)sendMessage
{
    
    if ([self.asyncSocket isConnected]) {
        
        for (int i = 0; i< MIN(self.sendArray.count, self.model.linkNum); i++) {
            
            NSArray *temp = self.sendArray[i];
            
            NSMutableString *string = [NSMutableString string];
            
            for (int j = 0; j < temp.count; j++) {
                
                if (j < temp.count - 1) {
                    [string appendString:[NSString stringWithFormat:@"%@ ",self.sendArray[i][j]]];
                }else
                {
                    [string appendString:[NSString stringWithFormat:@"%@",self.sendArray[i][j]]];
                }
                
            }
            
            NSData *requestData = [Utils convertHexStrToData:string];
            
            [[SocketManager shareManager].asyncSocket writeData:requestData withTimeout:-1 tag:0];
            [[SocketManager shareManager].asyncSocket readDataWithTimeout:-1 tag:0];
            
        }
        
    }
    
}


@end
