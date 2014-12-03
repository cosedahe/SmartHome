//
//  SocketMessage.h
//  SmartHome
//
//  Created by Fang minghua on 14-10-21.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// send protocol
static NSString* const REGEST = @"add";
static NSString* const STUDYCODE = @"studycode";
static NSString* const LOGIN = @"log";
static NSString* const CHANGEPWD = @"chgpw";
static NSString* const DOWNCODE = @"downcode";
static NSString* const NORMALCHECK = @"phoneid";
static NSString* const INRAREDRAY = @"ircode";
static NSString* const FORGETPASSWORD = @"getpw";
static NSString* const CURTCODE = @"curtcode";
static NSString* const UPCODES = @"upcode";
static NSString* const SELECTUPCODE = @"selectUpCode";
static NSString* const DLT = @"dlt";//警铃
// receive protocol
static NSString* const LOGINRESPONSE = @"<appid";
static NSString* const REGESTRESPONSE = @"<add";
static NSString* const DOWNCODERESPONSE = @"<downcoderesponse";
static NSString* const CHANGEPWDRESPONSE = @"<chgpw";
static NSString* const UPCODE = @"<dst";
static NSString* const RELOG = @"<app";
static NSString* const FORGETPASSWORDRESPONSE = @"<getpw";
static NSString* const APPMSG = @"<appmsg";
static NSString* const DATABASE = @"<database";
static NSString* TYPE;

@interface SocketMessage : NSObject {
@private long appid;
@private NSString *name;
@private NSString *pwd;
@private NSString *newpwd;
@private NSString *protocol;
@private long serverid;
@private NSString *studycode;
@private long upcode;
@private long downcode;
@private long ircode;
@private long ditcode; //删除警铃
@private NSString *mail;
@private NSString *curtcode;
@private NSString *selectUpCode;
@private int port;
}

+(SocketMessage *)getInstance;

-(long)getAppid;
-(void)setAppid:(long)id;
-(NSString *)getName;
-(void)setName:(NSString *)newName;
-(NSString *)getPwd;
-(void)setPwd:(NSString *)newPwd;
-(NSString *)getProtocol;
-(void)setProtocol:(NSString *)newProtocol;
-(long)getServerid;
-(void) setServerid:(long)newId;
-(NSString *)getStudyCode;
-(void)setStudyCode:(NSString *)newCode;
-(long)getUpcode;
-(void)setUpcode:(long)newCode;
-(long)getDowncode;
-(void)setDowncode:(long)newCode;
-(NSString *)getNewpwd;
-(void)setNewpwd:(NSString *)passwd;
-(long)getIrcode;
-(void)setIrcode:(long)newCode;
-(NSString *)getMail;
-(void)setMail:(NSString *)newMail;
-(NSString *)getCurtcode;
-(void)setCurtcode:(NSString *)newCode;
-(int)getPort;
-(void)setPort:(int)newPort;
-(long)getDitcode;
-(void)setDitcode:(long)newCode;
-(NSString *)getSelectUpCode;
-(void)setSelectUpCode:(NSString *)newCode;

-(void)sendRegestMessage:(NSString *)myName :(NSString *)myPwd :(NSString *)myMail;
-(void)sendLoginMessage:(NSString *)myName :(NSString *)myPwd;
-(void)sendChangePwdMessage:(NSString *)myName :(NSString *)myPwd :(NSString *)newPwd;
-(void)sendForgetPwdMessage:(NSString *)myName :(NSString *)myMail;
-(void)sendDownCode:(long)downcode;
-(void)sendIRCode:(long)ircode;
-(void)sendStudyCode:(NSString *)code;
-(void)sendCurtCode:(NSString *)code;
-(void)sendUpCode:(NSString *)code;
-(void)sendSelectCode:(NSString *)code;
-(void)sendDitCode:(long)code;

-(NSString *)getUdpSocketByCode:(NSString *)result;

@end
