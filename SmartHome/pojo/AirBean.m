//
//  AirBean.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-25.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "AirBean.h"

@implementation AirBean

-(NSString *)getWindspeed
{
    return windspeed;
}

-(void)setWindspeed:(NSString *)newSpeed
{
    windspeed = newSpeed;
}

-(int)getStudy
{
    return study;
}

-(void)setStudy:(int)newStudy
{
    study = newStudy;
}

-(NSString *)getName
{
    return name;
}

-(void)setName:(NSString *)newName
{
    name = newName;
}

-(NSString *)getTemp
{
    return tmp;
}

-(void)setTmp:(NSString *)newTmp
{
    tmp = newTmp;
}

-(NSString *)getModel
{
    return model;
}

-(void)setModel:(NSString *)newModel
{
    model = newModel;
}

-(int)getFurnitureid
{
    return furnitureid;
}

-(void)setFurnitureid:(int)newId
{
    furnitureid = newId;
}

-(long)getDowncode
{
    return downcode;
}

-(void)setDowncode:(long)newCode
{
    downcode = newCode;
}

@end
