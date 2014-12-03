//
//  ReceiveSocketThread.m
//  SmartHome
//
//  Created by heteli on 14-10-29.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "ReceiveSocketThread.h"
#import "AbstractSocket.h"

ReceiveSocketThread *instance;

@implementation ReceiveSocketThread : AbstractSocket
+(ReceiveSocketThread *)getInstance
{
    @synchronized(self) {
        if(instance == nil) {
            //instance = [[[self class] alloc] init]; //   assignment   not   done   here
            //instance = [[super allocWithZone:NULL] init];
            instance = [[ReceiveSocketThread alloc] init];
            //[instance initSth];
        }
    }
    
    return instance;
}

-(void)start
{
    //NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%d", ip, port]];
    NSThread *receiveSocketThread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveSocketThreadMethod) object:nil];
    [receiveSocketThread start];
}

+(void)receiveSocketThreadMethod
{
    NSLog(@"ReceiveSocketThread started!");
    
    instance->ip = [instance getIp];
    instance->port = [instance getPort];
    
    if (![instance isSocketconnectflag])
    {
        [instance setSocket:instance->ip :instance->port];
        [instance setSocketconnectflag:YES];
    }
    
    instance->_client = [instance getSocket];
    
    [instance getMessage];
}

-(void)getMessage
{
    flag = 1;
}

-(SocketMessage *)getSocketMessage
{
    SocketMessage *socketMessage = [SocketMessage getInstance];
    return socketMessage;
}

@end
