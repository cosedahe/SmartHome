//
//  UDPSocketTask.m
//  SmartHome
//
//  Created by heteli on 14-11-7.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "UDPSocketTask.h"
#import "SocketMessage.h"

static UDPSocketTask *repairSendSocketTask;


@implementation UDPSocketTask

+(UDPSocketTask *)getInstance
{
    @synchronized(self) {
        if(repairSendSocketTask == nil) {
            repairSendSocketTask = [[UDPSocketTask alloc] init];
        }
    }
    return repairSendSocketTask;
}

-(void)run
{
    [NSThread detachNewThreadSelector:@selector(runThread) toTarget:self withObject:nil];
}

-(void)runThread
{
    [self setUdpSocket:ip :port :[self sendMessage]];
}

-(NSData *)sendMessage
{
    NSString *message = [NSString alloc];
    SocketMessage *socketMessage = [SocketMessage getInstance];
    
    NSString *protocol = [socketMessage getProtocol];
    if([protocol isEqualToString:REGEST])
    {
        //message = @"<add=%@,%@,%@>"
        //message = @"<add=" + [socketMessage getName] + @"," + [socketMessage getPwd] + @"," + [socketMessage getMail] + @">";
        message = [message initWithFormat:@"<add=%@,%@,%@>",[socketMessage getName],[socketMessage getPwd],[socketMessage getMail]];
    }
    else if ([protocol isEqualToString:LOGIN])
    {
        message = [message initWithFormat:@"<log=%@,%@>",[socketMessage getName],[socketMessage getPwd]];
    }
    else if ([protocol isEqualToString:CHANGEPWD])
    {
        message = [message initWithFormat:@"<chgpw=%@,%@,%@>",[socketMessage getName],[socketMessage getPwd],[socketMessage getNewpwd]];
    }
    else if ([protocol isEqualToString:STUDYCODE])
    {
        message = [message initWithFormat:@"<dst=%ld,src=%ld,studycode=%@>",[socketMessage getServerid],[socketMessage getAppid],[socketMessage getStudyCode]];
    }
    else if ([protocol isEqualToString:DOWNCODE])
    {
        message = [message initWithFormat:@"<dst=%ld,src=%ld,downcode=%ld>",[socketMessage getServerid],[socketMessage getAppid],[socketMessage getDowncode]];
    }
    else if ([protocol isEqualToString:NORMALCHECK])
    {
        message = [message initWithFormat:@"PHONEID=%ld>",socketMessage.getAppid];
    }
    else if ([protocol isEqualToString:INRAREDRAY])
    {
        message = [message initWithFormat:@"<dst=%ld,src=%ld,ircode=%ld>",[socketMessage getServerid],[socketMessage getAppid],[socketMessage getIrcode]];
    }
    else if ([protocol isEqualToString:FORGETPASSWORD])
    {
        message = [message initWithFormat:@"<getpw=%@,%@>",[socketMessage getName],[socketMessage getMail]];
    }
    else if ([protocol isEqualToString:CURTCODE])
    {
        message = [message initWithFormat:@"<dst=%ld,src=%ld,curtcode=%@>",[socketMessage getServerid],[socketMessage getAppid],[socketMessage getCurtcode]];
    }
    else if ([protocol isEqualToString:UPCODES])
    {
        message = [message initWithFormat:@"<dst=%ld,src=%ld,upcode=%ld>",[socketMessage getServerid],[socketMessage getAppid],[socketMessage getUpcode]];
    }
    else if ([protocol isEqualToString:DLT])
    {
        message = [message initWithFormat:@"<dst=%ld,src=%ld,upcode=dlt:%ld>",[socketMessage getServerid],[socketMessage getAppid],[socketMessage getDitcode]];
    }
    else if ([protocol isEqualToString:SELECTUPCODE])
    {
        message = [message initWithFormat:@"<dst=%ld,src=%ld,upcode=%@>",[socketMessage getServerid],[socketMessage getAppid],[socketMessage getSelectUpCode]];
    }

    NSLog(@"%@", message);
    
    return [message dataUsingEncoding:NSUTF8StringEncoding];
}

@end
