//
//  ChatUtils.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-11.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUtils : NSObject

+(NSString *)bytesToHexString:(BytePtr)src;
+(NSString *)toHexString:(NSString *)s;
+(NSString *)toStringHex:(NSString *)s;
+(NSString *)toByteString:(BytePtr)src;
+(BOOL)isNumberic:(NSString *)str;

@end
