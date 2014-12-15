//
//  BaseBean.m
//  SmartHome
//
//  Created by He Teli on 14-11-14.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
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
