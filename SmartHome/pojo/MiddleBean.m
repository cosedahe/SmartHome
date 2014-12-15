//
//  MiddleBean.m
//  SmartHome
//
//  Created by He Teli on 14-11-26.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "MiddleBean.h"

@implementation MiddleBean

-(int)getPatternid
{
    return patternid;
}

-(void)setPatternid:(int)newPatternid
{
    patternid = newPatternid;
}

-(int)getWidgetid
{
    return widgetid;
}

-(void)setWidgetid:(int)newWidgetid
{
    widgetid = newWidgetid;
}

@end
