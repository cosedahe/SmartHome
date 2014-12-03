//
//  ReceiveSocketThread.h
//  SmartHome
//
//  Created by Fang minghua on 14-10-29.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "AbstractSocket.h"
#import "SocketMessage.h"

@interface ReceiveSocketThread : AbstractSocket
{
    NSString *ip;
    int port;
    // int client; // client socket fd
    CFSocketRef _client;
}
+(void)receiveSocketThreadMethod;
+(ReceiveSocketThread *)getInstance;
-(void)start;
-(void)getMessage;
-(SocketMessage *)getSocketMessage;
@end
