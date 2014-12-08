//
//  WidgetService.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-19.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
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
