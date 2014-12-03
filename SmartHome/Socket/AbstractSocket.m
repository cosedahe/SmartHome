//
//  AbstractSocket.m
//  SmartHome
//
//  Created by heteli on 14-10-27.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "AbstractSocket.h"
#import "AsyncSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

static CFSocketRef _socket = nil;
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
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)(ip), port, &readStream, &writeStream);
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputStream = (__bridge_transfer NSOutputStream
                     *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                            forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                             forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

-(CFSocketRef)getSocket
{
    return _socket;
}

-(Boolean)isSocketconnectflag{
    return socketconnectflag;
}

-(Boolean)isSocketConnect
{
    return CFSocketIsValid(_socket);
    //return mIsConnected;
}

-(void)setSocketconnectflag:(Boolean)setSocketconnectflag
{
    socketconnectflag = setSocketconnectflag;
}

-(void)close
{
    // TODO:how to close
    // close(socketfd);
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
}

-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    NSString *event;
    switch (streamEvent) {
        case NSStreamEventNone:
            event = @"NSStreamEventNone";
            break;
        case NSStreamEventOpenCompleted:
            event = @"NSStreamEventOpenCompleted";
            break;
        case NSStreamEventHasBytesAvailable:
            event = @"NSStreamEventHasBytesAvailable";
            if (flag ==1 && theStream == _inputStream) {
                NSMutableData *input = [[NSMutableData alloc] init];
                uint8_t temp[2046];
                int len;
                while([_inputStream hasBytesAvailable])
                {
                    len = [_inputStream read:temp maxLength:sizeof(temp)];
                    if (len > 0)
                    {
                        NSLog(@"size:%d", len);
                        [input appendBytes:temp length:len];
                    } else
                    {
                        break;
                    }
                }
                NSString *resultstring = [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
                NSLog(@"接收:%@",resultstring);
                //_message.text = resultstring;
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            event = @"NSStreamEventHasSpaceAvailable";
            if (flag ==0 && theStream == _outputStream) {
                //输出
                UInt8 buff[] = "Hello Server!";
                [_outputStream write:buff maxLength: strlen((const char*)buff)+1];
                //必须关闭输出流否则，服务器端一直读取不会停止，
                [_outputStream close];
            }
            break;
        case NSStreamEventErrorOccurred:
            event = @"NSStreamEventErrorOccurred";
            [self close];
            break;
        case NSStreamEventEndEncountered:
            event = @"NSStreamEventEndEncountered";
            NSLog(@"Error:%d:%@",[[theStream streamError] code], [[theStream streamError] localizedDescription]);
            break;
        default:
            [self close];
            event = @"Unknown";
            break;
    }
    NSLog(@"event------%@",event);
}



@end
