//
//  AbstractSocket.m
//  SmartHome
//
//  Created by Fang minghua on 14-10-27.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "AbstractSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

static CFSocketRef _socket = nil;
static int socketfd;
static Boolean socketconnectflag = false;
static int port;
static NSString *ip;
static Boolean mIsConnected = false;

static void UDPServerConnectCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if(data != NULL)
    {
        mIsConnected = false;
        NSLog(@"connect to server failed!");
        return;
    }
    mIsConnected = true;
}

@implementation AbstractSocket

-(int)getPort{
    return  port;
}

-(void)setPort:(int)p{
    port = p;
}

-(NSString *)getIp{
    return ip;
}

-(void)setIp:(NSString *)s{
    ip = s;
}

-(void)setSocket:(NSString *)s :(int)p
{
    socketfd = socket(AF_INET, SOCK_DGRAM, 0);
    if(socketfd == -1)
    {
        NSLog(@"create socket failed, errno = %d", errno);
        return;
    }
    
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(p);
    addr4.sin_addr.s_addr = inet_addr([s UTF8String]);
    bzero(&(addr4.sin_zero), 8);
    
    int conn = connect(socketfd, (struct sockaddr *)&addr4, sizeof(struct sockaddr));
    if (conn == -1)
    {
        mIsConnected = false;
        NSLog(@"connect to server failed, errno = %d", errno);
        return;
    }
    mIsConnected = true;
}

-(int)getSocket
{
    return socketfd;
}

-(Boolean)isSocketconnectflag{
    return socketconnectflag;
}

-(Boolean)isSocketConnect
{
    //return CFSocketIsValid(_socket);
    return mIsConnected;
}

-(void)setSocketconnectflag:(Boolean)setSocketconnectflag
{
    socketconnectflag = setSocketconnectflag;
}

-(void)closeSocket
{
    // TODO:how to close
    close(socketfd);
}

@end
