//
//  UDPSocketTask.h
//  SmartHome
//
//  Created by He Teli on 14-11-7.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractUdpSocket.h"

@interface UDPSocketTask : AbstractUdpSocket

+(UDPSocketTask *)getInstance;
-(void)run;
-(NSData *)sendMessage;

@end