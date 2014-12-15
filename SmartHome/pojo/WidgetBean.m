//
//  WidgetBean.m
//  SmartHome
//
//  Created by He Teli on 14-11-19.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "WidgetBean.h"

@implementation WidgetBean

-(int)getIndex
{
    return index;
}

-(void)setIndex:(int)newIndex
{
    index = newIndex;
}

-(int)getStatus
{
    return status;
}

-(void)setStatus:(int)newStatus
{
    status = newStatus;
}

-(int)getFurnitureId
{
    return furnitureId;
}

-(void)setFurnitureId:(int)newId
{
    furnitureId = newId;
}

-(long)getDowncode
{
    return downcode;
}

-(void)setDowncode:(long)newCode
{
    downcode = newCode;
}

-(NSString *)getTag
{
    return tag;
}

-(void)setTag:(NSString *)newTag
{
    tag = newTag;
}

-(long)getWidgetid
{
    return widgetid;
}

-(void)setWidgetid:(long)newId
{
    widgetid = newId;
}

@end
