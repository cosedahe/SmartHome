//
//  AbstractUdpSocket.h
//  SmartHome
//
//  Created by He Teli on 14-11-3.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnReceiverMessageListener.h"
#import "OnIfSucceedMessageListener.h"

static Boolean socketconnectflag;
/*static int port;
static NSString *ip;
static NSData *packet;*/

@interface AbstractUdpSocket : NSObject
{
    OnReceiverMessageListener *msgListener;
    OnIfSucceedMessageListener *onIfSucceedMessageListener;
    NSData *packet;
    BOOL isCommandProcessed;
    int port;
    NSString *ip;
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