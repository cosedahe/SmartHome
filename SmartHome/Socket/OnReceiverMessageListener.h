//
//  OnReceiverMessageListener.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-13.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnReceiverMessageListener : NSObject

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