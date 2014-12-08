//
//  AbstractUdpSocket.m
//  SmartHome
//
//  Created by heteli on 14-11-3.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "AbstractUdpSocket.h"
#import "SocketMessage.h"
#import "SocketChatUtils.h"
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/socket.h>

@implementation AbstractUdpSocket

/* 121.42.49.128:8000 */

-(id)init
{
    self = [super init];

    ip = @"121.42.49.128";
    //ip = @"58.215.235.62";
    port = 8000;
    isCommandProcessed = YES;
    
    return self;
}

-(void)setUdpSocket:(NSString *)newIp :(int)newPort :(NSData *)data
{
    [self sendAndReceive:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ipAddress:ip port:port];
}

-(NSString *)getUdpSocket:(NSString *)result
{
    NSArray* arr=[result componentsSeparatedByString:@">"];
    NSString *count = [arr objectAtIndex:0];
    count = [count stringByAppendingString:@">"];
    return count;
}

-(void)getSocketMessage:(NSString *)result
{
    if([result isEqualToString:@""]) // nothing in result, receive timeout
    {
        [onIfSucceedMessageListener getTimeOutMessage:@"timeout"];
        if(msgListener != nil)
        {
            [msgListener getAlarmBellMessage:[SocketChatUtils getCode:result]];
        }
        
    }
    
    NSString *protocol = [SocketChatUtils getprotocol:result :PROTOCOL];
    NSLog(@"protocol:%@",protocol);
    
    NSArray *contentArray = nil;
    NSString *content = @"";
    
    if([protocol isEqualToString:REGESTRESPONSE])
    {
        content = [SocketChatUtils getprotocol:result :CONTENT];
        NSLog(@"content:%@",content);
        contentArray = [content componentsSeparatedByString:@","];
        
        if([contentArray[0] isEqualToString:@"success>"])
        {
            //[msgListener getReceiveRegestResponseMessage:@"success"];
            [onIfSucceedMessageListener getTimeOutMessage:@"success"];
        }
        else if ([contentArray[0] isEqualToString:@"nameExist>"])
            //[msgListener getReceiveRegestResponseMessage:@"nameExist"];
            [onIfSucceedMessageListener getTimeOutMessage:@"nameExist"];
        else if ([contentArray[0] isEqualToString:@"mailExist>"])
            //[msgListener getReceiveRegestResponseMessage:@"mailExist"];
            [onIfSucceedMessageListener getTimeOutMessage:@"mailExist"];
        else
            //[msgListener getReceiveRegestResponseMessage:@"fail"];
            [onIfSucceedMessageListener getTimeOutMessage:@"fail"];
    }
    else if ([protocol isEqualToString:LOGINRESPONSE])
    {
        content = [SocketChatUtils getprotocol:result :CONTENT];
        NSLog(@"content:%@", content);
        contentArray = [content componentsSeparatedByString:@","];
        
        if([contentArray[0] isEqualToString:@"fail>"])
            //[msgListener getReceiveLoginResponseMessage:@"fail"];
            [onIfSucceedMessageListener getTimeOutMessage:@"fail"];
        else if ([contentArray[0] isEqualToString:@"nameError>"])
            //[msgListener getReceiveLoginResponseMessage:@"nameError"];
            [onIfSucceedMessageListener getTimeOutMessage:@"nameError"];
        else if ([contentArray[0] isEqualToString:@"passwordError>"])
            //[msgListener getReceiveLoginResponseMessage:@"passwordError"];
            [onIfSucceedMessageListener getTimeOutMessage:@"passwordError"];
        else
        {
            NSString *temp = [SocketChatUtils removeLastChat:contentArray[0]];
            @try {
                [[SocketMessage getInstance] setAppid:[temp intValue]];
            }
            @catch (NSException *exception) {
                NSLog(@"Exception:%@", exception);
                //[msgListener getReceiveLoginResponseMessage:@"fail"];
                [onIfSucceedMessageListener getTimeOutMessage:@"fail"];
                return;
            }
            @finally {
            }
            
            //[msgListener getReceiveLoginResponseMessage:@"success"];
            [onIfSucceedMessageListener getTimeOutMessage:@"success"];
        }
    }
    else if ([protocol isEqualToString:CHANGEPWDRESPONSE])
    {
        content = [SocketChatUtils getprotocol:result :CONTENT];
        NSLog(@"content:%@", content);
        contentArray = [content componentsSeparatedByString:@","];
        
        if([[contentArray objectAtIndex:0] isEqualToString:@"success>"])
            //[msgListener getReceiveChangePwdResponseMessage:@"success"];
            [onIfSucceedMessageListener getTimeOutMessage:@"success"];
        else if ([[contentArray objectAtIndex:0] isEqualToString:@"nameError>"])
            //[msgListener getReceiveChangePwdResponseMessage:@"nameError"];
            [onIfSucceedMessageListener getTimeOutMessage:@"nameError"];
        else if ([[contentArray objectAtIndex:0] isEqualToString:@"passwordError>"])
            //[msgListener getReceiveChangePwdResponseMessage:@"passwordError"];
            [onIfSucceedMessageListener getTimeOutMessage:@"passwordError"];
        else
            //[msgListener getReceiveChangePwdResponseMessage:@"fail"];
            [onIfSucceedMessageListener getTimeOutMessage:@"fail"];
    }
    else if ([protocol isEqualToString:UPCODE])
    {
        if([[[[[result componentsSeparatedByString:@","] objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:0] isEqualToString:@"upcode"])
        {
            if(msgListener != nil)
            {
                [msgListener getAlarmBellMessage:[SocketChatUtils getCode:result]];
            }
        }
        else
        {
#warning impelement getReceiveUpcodeMessage
            //[msgListener getReceiveUpcodeMessage:[SocketChatUtils judgeIfDowncode:result]];
            long codeId = [SocketChatUtils judgeIfDowncode:result];
            if(codeId != -1)
            {
                if(onIfSucceedMessageListener != nil)
                {
                    [onIfSucceedMessageListener getTimeOutMessage:@"success"];
                }
            }
            else
            {
                if(onIfSucceedMessageListener != nil)
                {
                    [onIfSucceedMessageListener getTimeOutMessage:@"fail"];
                }
            }
        }
    }
    else if ([protocol isEqualToString:FORGETPASSWORDRESPONSE])
    {
        content = [SocketChatUtils getprotocol:result :CONTENT];
        NSLog(@"content:%@", content);
        contentArray = [content componentsSeparatedByString:@","];
        
        if([[contentArray objectAtIndex:0] isEqualToString:@"success>"])
            //[msgListener getReceiveForgetPwdMessage:@"success"];
            [onIfSucceedMessageListener getTimeOutMessage:@"success"];
        else if ([[contentArray objectAtIndex:0] isEqualToString:@"mailError>"])
            //[msgListener getReceiveForgetPwdMessage:@"mailError"];
            [onIfSucceedMessageListener getTimeOutMessage:@"mailError"];
        else if ([[contentArray objectAtIndex:0] isEqualToString:@"mailSendError>"])
            //[msgListener getReceiveForgetPwdMessage:@"mailSendError"];
            [onIfSucceedMessageListener getTimeOutMessage:@"mailSendError"];
        else if ([[contentArray objectAtIndex:0] isEqualToString:@"nameError>"])
            //[msgListener getReceiveForgetPwdMessage:@"nameError"];
            [onIfSucceedMessageListener getTimeOutMessage:@"nameError"];
        else
            //[msgListener getReceiveForgetPwdMessage:@""];
            [onIfSucceedMessageListener getTimeOutMessage:@""];
    }
}

-(BOOL)isSocketconnectflag
{
    return socketconnectflag;
}

-(void)setSocketconnectflag:(BOOL)flag
{
    socketconnectflag = flag;
}

-(void)setReceiveMessageListerner:(OnReceiverMessageListener *)listener
{
    msgListener = listener;
}

-(void)setSucceedMessageListener:(OnIfSucceedMessageListener *)listener
{
    onIfSucceedMessageListener = listener;
}

-(void)removeReceiveMessageListerner
{
    msgListener = nil;
}

-(void)removeSucceedMessageListener
{
    onIfSucceedMessageListener = nil;
}

static int socketId;
struct sockaddr_in destination;
struct timeval tv_out;
fd_set readfds, writefds;
int count = 0;

-(BOOL) sendAndReceive:(NSString*) msg ipAddress:(NSString*) myIp port:(int) p
{
    isCommandProcessed = NO;
	int sock;
	unsigned long echolen;
    
    NSLog(@"Sending message: %@", msg);
    
	if (msg == nil || myIp == nil)
	{
		printf("Message and/or ip address is null\n");
        isCommandProcessed = YES;
		return false;
	}
    
	/* Create the UDP socket */
	if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
	{
 		printf("Failed to create socket\n");
        isCommandProcessed = YES;
        return false;
	}
    
	/* Construct the server sockaddr_in structure */
	memset(&destination, 0, sizeof(destination));
    
	/* Clear struct */
	destination.sin_family = AF_INET;
    
	/* Internet/IP */
	destination.sin_addr.s_addr = inet_addr([ip UTF8String]);
    
	/* IP address */
	destination.sin_port = htons(p);
    
	/* server port */

	char *cmsg = (char *)[msg UTF8String];
    echolen = strlen(cmsg);
    
	// set send and receive timeout
    tv_out.tv_sec = 2;
    tv_out.tv_usec = 0;

    int flags = fcntl(sock, F_GETFL, 0);
    fcntl(sock, F_SETFL, flags | O_NONBLOCK);
    FD_ZERO(&writefds);
    FD_SET(sock, &writefds);
    @try
    {
        if(select(sock+1, NULL, &writefds, NULL, &tv_out) > 0)
        {
            if(FD_ISSET(sock, &writefds) > 0)
            {
                count++;
                if (sendto(sock,
                           cmsg,
                           echolen,
                           0,
                           (struct sockaddr *) &destination,
                           sizeof(destination)) != echolen)
                {
                    printf("Mismatch in number of sent bytes, errno = %d\n", errno);
                    count = 0;
                    isCommandProcessed = YES;
                    return false;
                }
                else
                {
                    socketId = sock;
                    BOOL ret = [self receiveThread];
                    if(ret)
                    {
                        count = 0;
                        isCommandProcessed = YES;
                        return true;
                    }
                    else if(count < 3)
                    {
                        [self sendAndReceive:msg ipAddress:ip port:p];
                    }
                }
            }
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"%@", e);
    }
    
    count = 0;
    isCommandProcessed = YES;
    return false;
}

// thread used to receive socket data
-(BOOL)receiveThread
{
    BOOL ret = false;
    NSString *result = [[NSString alloc] init];
    
    char buffer[128];
    memset(buffer, 0, sizeof(buffer));
    int addr_len =sizeof(struct sockaddr_in);
    /*if (setsockopt(socketId,
                   SOL_SOCKET,
                   SO_RCVTIMEO,
                   &tv_out,
                   sizeof(tv_out)) == -1)
	{
		perror("setsockopt (SO_RCVTIMEO)");
		exit(1);
	}*/
    /* use select instead */
    FD_ZERO(&readfds);
    FD_SET(socketId, &readfds);
    // set send and receive timeout
    tv_out.tv_sec = 2;
    tv_out.tv_usec = 0;
    int retVal = 0;
    @try
    {
        retVal = select(socketId+1, &readfds, NULL, NULL, &tv_out);
        NSLog(@"retVal = %d", retVal);
        if(retVal >= 0)
        {
            if(FD_ISSET(socketId, &readfds) > 0)
            {
                int len = recvfrom(socketId, buffer, sizeof(buffer), 0, (struct sockaddr*)&destination, (socklen_t *)&addr_len);
                if(len<0)
                    printf("####%d\n", errno);
                if(len>0)
                {
                    NSString *myData = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
                    NSLog(@"UDP socket receive packet!, data = %@", myData);
                    
                    packet = [myData dataUsingEncoding:NSASCIIStringEncoding];
                    if([@"upcodes" isEqualToString:TYPE])
                    {
                        NSLog(@"Receive upcodes");
                        result = [[SocketMessage getInstance] getUdpSocketByCode:myData];
                        /*if (result)
                        {
                            [self getSocketMessage:result];
                        }*/
                    }
                    else
                    {
                        result = [self getUdpSocket:myData];
                        /*if(result)
                        {
                            [self getSocketMessage:result];
                        }*/
                    }
                    ret = true;
                }
            }
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"%@", e);
    }
    
    if(![result isEqualToString:@""])
    {
        [self getSocketMessage:result];
    }
    else if(count >= 3)
    {
        [self getSocketMessage:result];
    }

    close(socketId);
    socketId = -1;
    return ret;
}

@end