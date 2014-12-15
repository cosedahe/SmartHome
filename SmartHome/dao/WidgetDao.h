//
//  WidgetDao.h
//  SmartHome
//
//  Created by He Teli on 14-11-19.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "BaseDao.h"
#import "SocketMessage.h"
#import "WidgetBean.h"
#import "FurnitureBean.h"

@interface WidgetDao : BaseDao
{
@private SocketMessage *socketmessage;
}

-(int)add:(WidgetBean *)bean;
-(void)deleteObj:(WidgetBean *)bean;
-(void)updateObj:(WidgetBean *)bean;
-(NSMutableArray *)getAll;
-(WidgetBean *)getInstanceById:(int)id;
-(long)getMaxDownCode;
-(long)getDownCodeByWidgetId:(int)widgetid;
-(NSMutableArray *)getListByFatherId:(int)fatherid;
-(NSMutableArray *)getListByFatherIdAndWIdgetId:(int)fatherid :(int)widgetid;
-(void)deleteByFatherId:(int)fatherId;
-(WidgetBean *)getWighetById:(int)myId;
-(NSMutableArray *)getListByTag:(NSString *)myTag;
-(WidgetBean *)getIdByDownCode:(long)myCode;
-(long)getValidMaxdowncode;

@end
