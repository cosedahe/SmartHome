//
//  UpdateManager.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-4.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "UpdateManager.h"

@implementation UpdateManager

-(NSDictionary *)getRemoteVersionInfo
{
    NSURL *url = [NSURL URLWithString:@"http://www.chongchi-tech.com/ccsoft/uploads/app/updateInfo.txt"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *response = [[NSString alloc] initWithData:data encoding:enc];
    //NSString *response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"response:%@", response);
    
    NSError *err = nil;
    NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    if (err)
    {
        NSLog(@"An error hanppened, Error = %@", err);
        return nil;
    }
    
    return resDict;
}

-(Boolean)checkVersion:(NSDictionary *)dict
{
    if(dict == nil)
    {
        return NO;
    }
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* localVersion =[infoDict objectForKey:@"CFBundleVersion"];
    NSString* newVersion = [dict objectForKey:@"VerCode"];
    
    return ![localVersion isEqualToString:newVersion];
}

@end
