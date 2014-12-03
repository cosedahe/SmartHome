//
//  RoomBean.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "RoomBean.h"

@implementation RoomBean

-(NSString *)getImagePath
{
    return ImagePath;
}

-(void)setImagePath:(NSString *)imagePath
{
    ImagePath = imagePath;
}

-(NSString *)getName
{
    return name;
}

-(void)setName:(NSString *)newName
{
    name = newName;
}

-(NSMutableArray *)getFurniturelist
{
    return furniturelist;
}

-(void)setFurniturelist:(NSMutableArray *)list
{
    furniturelist = list;
}

-(NSString *)getUserName
{
    return userName;
}

-(void)setUserName:(NSString *)newName
{
    userName = newName;
}

-(long)getDeviceNum
{
    return deviceNum;
}

-(void)setDeviceNum:(long)newNum
{
    deviceNum = newNum;
}

-(NSString *)getDescription
{
    return description;
}

-(void)setDescription:(NSString *)newDescription
{
    description = newDescription;
}

@end
