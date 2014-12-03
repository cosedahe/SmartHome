//
//  OnIfSucceedMessageListener.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-21.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnIfSucceedMessageListener : NSObject
@property NSString *socketResult;
@property BOOL dataReceived;

-(void)getTimeOutMessage:(NSString *)count;

@end
