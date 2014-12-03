//
//  BaseBean.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-14.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseBean.h"

@implementation BaseBean

-(int)getId
{
    return beanId;
}

-(void)setId:(int)newId
{
    beanId = newId;
}

@end
