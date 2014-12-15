//
//  ChatUtils.h
//  SmartHome
//
//  Created by He Teli on 14-11-11.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUtils : NSObject

+(NSString *)bytesToHexString:(BytePtr)src;
+(NSString *)toHexString:(NSString *)s;
+(NSString *)toStringHex:(NSString *)s;
+(NSString *)toByteString:(BytePtr)src;
+(BOOL)isNumberic:(NSString *)str;

@end
