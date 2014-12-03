//
//  AbstractUdpSocket.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-3.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
#import "OnReceiverMessageListener.h"
#import "OnIfSucceedMessageListener.h"

static AsyncUdpSocket *_socket;
static Boolean socketconnectflag;
static int port;
static NSString *ip;
static NSData *packet;

@interface AbstractUdpSocket : NSObject <AsyncUdpSocketDelegate>
{
    OnReceiverMessageListener *msgListener;
    OnIfSucceedMessageListener *onIfSucceedMessageListener;
@private NSData *packet;
}

-(void)setUdpSocket:(NSString *)newIp :(int)newPort :(NSData *)data;
-(NSString *)getUdpSocket:(NSString *)result;
-(BOOL)isSocketconnectflag;
-(void)setSocketconnectflag:(BOOL)flag;
-(void)setReceiveMessageListerner:(OnReceiverMessageListener *)listener;
-(void)setSucceedMessageListener:(OnIfSucceedMessageListener *)listener;
-(void)removeReceiveMessageListerner;
-(void)removeSucceedMessageListener;

@end
/*
@protocol OnReceiverMessageListener
@optional
-(void)getReceiveRegestResponseMessage:(NSString *)socketconnect;
-(void)getReceiveLoginResponseMessage:(NSString *)socketconnect;
-(void)getReceiveChangePwdResponseMessage:(NSString *)socketconnect;
//-(void)getReceiveDowncoderesponseMessage:(long)downcode;
-(void)getReceiveReLogMessage:(Boolean)relogflag;
-(void)getReceiveForgetPwdMessage:(NSString *)issuccessflag;
-(void)getReceiveUpcodeMessage:(long)upcode;
-(void)getTimeOutMessage;
-(void)getAlarmBellMessage:(NSMutableArray *)count; // long
-(void)getAppmsgMessage:(NSString *)relogflag;
@end

@protocol OnIfSucceedMessageListener
@optional
-(void)getTimeOutMessage:(NSString *)count;
@end
*/