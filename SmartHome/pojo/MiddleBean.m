//
//  MiddleBean.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-26.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
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
