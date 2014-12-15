//
//  UserBean.m
//  SmartHome
//
//  Created by He Teli on 14-11-14.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "UserBean.h"

@implementation UserBean

-(NSString *)getName
{
    return name;
}

-(void)setName:(NSString *)newName
{
    name = newName;
}

-(long)getDevice_number
{
    return device_number;
}

-(void)setDevice_number:(long)newNumber
{
    device_number = newNumber;
}

-(NSMutableArray *)getDeices
{
    return devices;
}

-(void)setDevices:(NSMutableArray *)newDevices
{
    devices = newDevices;
}


@end
