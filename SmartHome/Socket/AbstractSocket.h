//
//  AbstractSocket.h
//  SmartHome
//
//  Created by Fang minghua on 14-10-27.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractSocket : NSObject<NSStreamDelegate>
{
    int flag ; //操作标志 0为发送 1为接收
}

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;

-(int)getPort;
-(void)setPort:(int)p;
-(NSString *)getIp;
-(void)setIp:(NSString *)s;
-(void)setSocket:(NSString *)s :(int)p;
-(Boolean)isSocketconnectflag;
-(Boolean)isSocketConnect;
-(void)setSocketconnectflag:(Boolean)setSocketconnectflag;
-(void)close;
-(CFSocketRef)getSocket;

@end
