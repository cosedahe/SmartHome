//
//  SocketMessage.m
//  SmartHome
//
//  Created by Fang minghua on 14-10-21.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SocketMessage.h"
#import "UDPSocketTask.h"

static SocketMessage *instance = nil;

@implementation SocketMessage

+(SocketMessage *)getInstance{
    @synchronized(self) {
        if(instance == nil) {
            //instance = [[[self class] alloc] init]; //   assignment   not   done   here
            //instance = [[super allocWithZone:NULL] init];
            instance = [[SocketMessage alloc] init];
            [instance initSth];
        }
    }
    return instance;
}

-(void)initSth
{
    // TODO: new a sendsocketthread
    // sendSocketThread = UDPSendSocketThread.getInstance();
}

-(long)getAppid
{
    return appid;
}

-(void)setAppid:(long)id
{
    appid = id;
}

-(NSString *)getName
{
    return name;
}

-(void)setName:(NSString *)newName
{
    name = newName;
}

-(NSString *)getPwd
{
    return pwd;
}

-(void)setPwd:(NSString *)newPwd
{
    pwd = newPwd;
}

-(NSString *)getProtocol
{
    return protocol;
}

-(void)setProtocol:(NSString *)newProtocol
{
    protocol = newProtocol;
}

-(long)getServerid
{
    return serverid;
}

-(void) setServerid:(long)newId
{
    serverid = newId;
}

-(NSString *)getStudyCode
{
    return studycode;
}

-(void)setStudyCode:(NSString *)newCode
{
    studycode = newCode;
}

-(long)getUpcode
{
    return upcode;
}

-(void)setUpcode:(long)newCode
{
    upcode = newCode;
}

-(long)getDowncode
{
    return downcode;
}

-(void)setDowncode:(long)newCode
{
    downcode = newCode;
}

-(NSString *)getNewpwd
{
    return newpwd;
}

-(void)setNewpwd:(NSString *)passwd
{
    newpwd = passwd;
}

-(long)getIrcode
{
    return ircode;
}

-(void)setIrcode:(long)newCode
{
    ircode = newCode;
}

-(NSString *)getMail
{
    return mail;
}

-(void)setMail:(NSString *)newMail
{
    mail = newMail;
}

-(NSString *)getCurtcode
{
    return curtcode;
}

-(void)setCurtcode:(NSString *)newCode
{
    curtcode = newCode;
}

-(int)getPort
{
    return port;
}

-(void)setPort:(int)newPort
{
    port = newPort;
}

-(long)getDitcode
{
    return ditcode;
}

-(void)setDitcode:(long)newCode
{
    ditcode = newCode;
}

-(NSString *)getSelectUpCode
{
    return selectUpCode;
}

-(void)setSelectUpCode:(NSString *)newCode
{
    selectUpCode = newCode;
}

-(void)sendRegestMessage:(NSString *)myName :(NSString *)myPwd :(NSString *)myMail
{
    [instance setName:myName];
    [instance setPwd:myPwd];
    [instance setMail:myMail];
    [instance setProtocol:REGEST];
    
    // TODO: new a send socket thread
    [[UDPSocketTask getInstance] run];
}

-(void)sendLoginMessage:(NSString *)myName :(NSString *)myPwd
{
    [instance setName:myName];
    [instance setPwd:myPwd];
    [instance setProtocol:LOGIN];
    
    [[UDPSocketTask getInstance] run];
}

-(void)sendChangePwdMessage:(NSString *)myName :(NSString *)myPwd :(NSString *)newPwd
{
    [instance setName:myName];
    [instance setPwd:myPwd];
    [instance setNewpwd:newPwd];
    [instance setProtocol:CHANGEPWD];
    
    [[UDPSocketTask getInstance] run];
}

-(void)sendForgetPwdMessage:(NSString *)myName :(NSString *)myMail
{
    [instance setProtocol:FORGETPASSWORD];
    [instance setName:myName];
    [instance setMail:myMail];
    
    [[UDPSocketTask getInstance] run];
}

-(void)sendDownCode:(long)code
{
    TYPE = @"downcode";
    [instance setProtocol:DOWNCODE];
    [instance setDowncode:code];
    
    [[UDPSocketTask getInstance] run];
}

-(void)sendIRCode:(long)code
{
    TYPE = @"ircode";
    [instance setProtocol:INRAREDRAY];
    [instance setIrcode:code];
    
    [[UDPSocketTask getInstance] run];
}

-(void)sendStudyCode:(NSString *)code
{
    TYPE = @"studycode";
    [instance setProtocol:STUDYCODE];
    [instance setStudyCode:code];
    
    [[UDPSocketTask getInstance] run];
}

-(void)sendCurtCode:(NSString *)code
{
    TYPE = @"curtcode";
    [instance setProtocol:CURTCODE];
    [instance setCurtcode:code];
    [[UDPSocketTask getInstance] run];
}

-(void)sendUpCode:(NSString *)code /* study code */
{
    TYPE = @"upcodes";
    [instance setProtocol:UPCODES];
    [instance setCurtcode:code];
    
    [[UDPSocketTask getInstance] run];
}

-(void)sendSelectCode:(NSString *)code
{
    TYPE = @"selectUpCode";
    [instance setProtocol:SELECTUPCODE];
    [instance setSelectUpCode:selectUpCode];
    
    [[UDPSocketTask getInstance] run];
}

-(void)sendDitCode:(long)code
{
    TYPE = @"dit";
    [instance setProtocol:DLT];
    [instance setDitcode:ditcode];
    
    [[UDPSocketTask getInstance] run];
}

-(NSString *)getUdpSocketByCode:(NSString*)result
{
    NSArray* arr=[result componentsSeparatedByString:@">"];
    NSString *count = [arr objectAtIndex:0];
    count = [count stringByAppendingString:@">"];
    return count;
}

@end
