//
//  UDPSocketTask.h
//  SmartHome
//
//  Created by heteli on 14-11-7.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractUdpSocket.h"

@interface UDPSocketTask : AbstractUdpSocket

+(UDPSocketTask *)getInstance;
-(void)run;
-(NSData *)sendMessage;

@end