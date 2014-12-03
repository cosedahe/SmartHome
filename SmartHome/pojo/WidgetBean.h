//
//  WidgetBean.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-19.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseBean.h"

@interface WidgetBean : BaseBean
{
@private int furnitureId;
@private long downcode;
@private NSString *tag;
@private long widgetid;
@private int status;
@private int index;
}

-(int)getIndex;
-(void)setIndex:(int)newIndex;
-(int)getStatus;
-(void)setStatus:(int)newStatus;
-(int)getFurnitureId;
-(void)setFurnitureId:(int)newId;
-(long)getDowncode;
-(void)setDowncode:(long)newCode;
-(NSString *)getTag;
-(void)setTag:(NSString *)newTag;
-(long)getWidgetid;
-(void)setWidgetid:(long)newId;

@end
