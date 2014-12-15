//
//  OnIfSucceedMessageListener.m
//  SmartHome
//
//  Created by He Teli on 14-11-21.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "OnIfSucceedMessageListener.h"

@implementation OnIfSucceedMessageListener

-(void)getTimeOutMessage:(NSString *)count
{
    self.dataReceived = YES;
    self.socketResult = count;
}

@end
