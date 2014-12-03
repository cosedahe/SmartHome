//
//  SocketChatUtils.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-11.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SocketChatUtils.h"

@implementation SocketChatUtils

+(NSString *)getprotocol:(NSString *)src :(int)flag
{
    switch(flag)
    {
        case PROTOCOL:
            return [[src componentsSeparatedByString:@"="] objectAtIndex:0];
        case CONTENT:
            return [[src componentsSeparatedByString:@"="] objectAtIndex:1];
            default:
            break;
    }
    return nil;
}

+(NSString *)removeLastChat:(NSString *)src
{
    return [src substringWithRange:NSMakeRange(0, src.length - 1)];
}

+(NSMutableArray *)getCode:(NSString *)count
{
    SocketMessage *socketmessage = [SocketMessage getInstance];
    NSMutableArray *counts = [[NSMutableArray alloc] initWithArray:[count componentsSeparatedByString:@","]];
    NSString *dst = [[[counts objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
    NSString*src = [[[counts objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
    NSMutableArray *codes = [[NSMutableArray alloc] initWithArray:[[[[counts objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1] componentsSeparatedByString:@","]];
    NSMutableArray *listCode = [[NSMutableArray alloc] init];
    if([counts count] == 3)
    {
        NSString *temp = [self removeLastChat:[codes objectAtIndex:0]];
        // [listCode addObject:[temp longLongValue]];
        [listCode addObject:temp];
    }
    else
    {
        for(int i = 0; i < [counts count] - 2; i++)
        {
            if(i == [counts count] - 3)
               [listCode addObject:[self removeLastChat:[counts objectAtIndex:([counts count] - 1)]]];
            else if(i == 0)
                [listCode addObject:[[[[[counts objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1] componentsSeparatedByString:@","] objectAtIndex:0]];
            else
                [listCode addObject:[counts objectAtIndex:(i + 2)]];
        }
    }
    
    if([dst isEqualToString:[[NSString alloc] initWithFormat:@"%ld",[socketmessage getAppid]]] && [src isEqualToString:[[NSString alloc] initWithFormat:@"%ld",[socketmessage getServerid]]])
        return listCode;
    
    return  nil;
}

+(long)judgeIfDowncode:(NSString *)count
{
    SocketMessage *socketmessage = [SocketMessage getInstance];

    NSMutableArray *counts = [[NSMutableArray alloc] initWithArray:[count componentsSeparatedByString:@","]];
    NSString *dst = [[[counts objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
    NSString *src = [[[counts objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
    NSString *upCodeName = [[NSString alloc] init];
    upCodeName = [[[counts objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:0];
    
    if([upCodeName isEqualToString:@"upcode"])
    {
        NSString *compareTemp = [self removeLastChat:[[[counts objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1]];
        if([[socketmessage getStudyCode] isEqualToString:compareTemp])
            return [compareTemp intValue];
    }
    else if ([upCodeName isEqualToString:@"ack"])
    {
        NSString *codeName = [[[[[counts objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:0];
        NSString *code = [ self removeLastChat:[[[[[counts objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] ];
        if([dst isEqualToString:[[NSString alloc] initWithFormat:@"%ld",[socketmessage getAppid]]] && [src isEqualToString:[[NSString alloc] initWithFormat:@"%ld",[socketmessage getServerid]]])
        {
            if([codeName isEqualToString:@"downcode"])
            {
                if([code isEqualToString:[[NSString alloc] initWithFormat:@"%ld",[socketmessage getDowncode]]])
                    return [code intValue];
            }
            else if ([codeName isEqualToString:@"studycode"])
            {
                if([code isEqualToString:[socketmessage getStudyCode]])
                    return [code intValue];
            }
            else if ([codeName isEqualToString:@"ircode"])
            {
                if([code isEqualToString:[[NSString alloc] initWithFormat:@"%ld",[socketmessage getIrcode]]])
                    return [code intValue];
            }
            else if ([codeName isEqualToString:@"curtcode"])
            {
                if([code isEqualToString:[socketmessage getCurtcode]])
                    return [code intValue];
            }
        }
    }
    
    return -1;
}

@end
