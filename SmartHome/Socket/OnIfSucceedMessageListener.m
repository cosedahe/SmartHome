//
//  OnIfSucceedMessageListener.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-21.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "OnIfSucceedMessageListener.h"

@implementation OnIfSucceedMessageListener

-(void)getTimeOutMessage:(NSString *)count
{
    self.dataReceived = YES;
    self.socketResult = count;
}

@end
