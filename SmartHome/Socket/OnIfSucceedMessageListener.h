//
//  OnIfSucceedMessageListener.h
//  SmartHome
//
//  Created by He Teli on 14-11-21.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnIfSucceedMessageListener : NSObject
@property NSString *socketResult;
@property BOOL dataReceived;

-(void)getTimeOutMessage:(NSString *)count;

@end
