//
//  ChatUtils.m
//  SmartHome
//
//  Created by He Teli on 14-11-11.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "ChatUtils.h"

@implementation ChatUtils

+(BOOL)isNumberic:(NSString *)str
{
    return YES;
    NSScanner* scan = [NSScanner scannerWithString:str];
    long val;
    return[scan scanLongLong:(long long *)&val] && [scan isAtEnd];
}

@end
