//
//  AirService.h
//  SmartHome
//
//  Created by He Teli on 14-11-25.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketMessage.h"
#import "AirDao.h"
#import "FurnitureDao.h"
#import "WidgetDao.h"
#import "MiddleBean.h"
#import "MiddleDao.h"
#import "FurnitureBean.h"
#import "WidgetBean.h"

@interface AirService : NSObject
{
@private SocketMessage *socketmessage;
@private AirDao *airdao;
@private FurnitureDao *furnituredao;
@private WidgetDao *widgetdao;
@private NSMutableArray *middles;
@private MiddleDao *imiddledao;
@private NSMutableArray *fun;   // furnitureBean list
@private NSMutableArray *widgets;  //widgetbean
}

-(void)deleteT:(AirBean *)bean;
-(NSMutableArray *)getChildrenById:(int)myId;
-(int)addWidget:(AirBean *)bean;
-(long)getDownCodeById:(long)downcode;


@end
