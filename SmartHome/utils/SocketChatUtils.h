//
//  SocketChatUtils.h
//  SmartHome
//
//  Created by He Teli on 14-11-11.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "ChatUtils.h"
#import "SocketMessage.h"

static const int PROTOCOL = 0x01;
static const int CONTENT = 0x02;

@interface SocketChatUtils : ChatUtils

+(NSString *)getprotocol:(NSString *)src :(int)flag;
+(NSString *)removeLastChat:(NSString *)src;
+(long)judgeIfDowncode:(NSString *)count;
// static list<long> getCode(string count)
+(NSMutableArray *)getCode:(NSString *)count;

@end
