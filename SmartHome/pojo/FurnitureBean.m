//
//  FurnitureBean.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-18.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "FurnitureBean.h"

@implementation FurnitureBean

-(NSString *)getLastdo
{
    return lastdo;
}

-(void)setLastdo:(NSString *)doing
{
    lastdo = doing;
}

-(NSString *)getDescription
{
    return description;
}

-(void)setDescription:(NSString *)newDescription
{
    description = newDescription;
}

-(int)getRoomId
{
    return roomId;
}

-(void)setRoomId:(int)newRoomId
{
    roomId = newRoomId;
}

-(NSString *)getName
{
    return name;
}

-(void)setName:(NSString *)newName
{
    name = newName;
}

-(NSString *)getTag
{
    return tag;
}

-(void)setTag:(NSString *)newTag
{
    tag = newTag;
}

-(long)getDowncode
{
    return downcode;
}

-(void)setDowncode:(long)newCode
{
    downcode = newCode;
}

-(NSMutableArray *)getWidgetlist
{
    return widgetlist;
}

-(void)setWidgetlist:(NSMutableArray *)newlist
{
    widgetlist = newlist;
}

// bool equals(object destionation)

@end
