//
//  AirBean.h
//  SmartHome
//
//  Created by He Teli on 14-11-25.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBean.h"

@interface AirBean : BaseBean
{
    NSString *tmp;
    NSString *model;
    int id;
    int furnitureid;
    long downcode;
    NSString *name;
    int study;
    NSString *windspeed;
}

-(NSString *)getWindspeed;
-(void)setWindspeed:(NSString *)newSpeed;
-(int)getStudy;
-(void)setStudy:(int)newStudy;
-(NSString *)getName;
-(void)setName:(NSString *)newName;
-(NSString *)getTemp;
-(void)setTmp:(NSString *)newTmp;
-(NSString *)getModel;
-(void)setModel:(NSString *)newModel;
-(int)getFurnitureid;
-(void)setFurnitureid:(int)newId;
-(long)getDowncode;
-(void)setDowncode:(long)newCode;

@end
