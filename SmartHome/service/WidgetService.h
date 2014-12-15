//
//  WidgetService.h
//  SmartHome
//
//  Created by He Teli on 14-11-19.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WidgetBean.h"
#import "WidgetDao.h"
#import "FurnitureBean.h"
#import "SocketMessage.h"

@interface WidgetService : NSObject
{
@private SocketMessage *socketmessage;
@private WidgetDao *widgetdao;
}

-(void)sendDowncode:(int)index :(NSMutableArray *)widgetlist;
-(NSMutableArray *)addWidget:(FurnitureBean *)furniture :(NSMutableArray *)buttonlist;

@end
