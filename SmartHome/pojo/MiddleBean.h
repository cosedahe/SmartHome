//
//  MiddleBean.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-26.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseBean.h"

@interface MiddleBean : BaseBean
{
@private int patternid;
@private int widgetid;
}

-(int)getPatternid;
-(void)setPatternid:(int)newPatternid;
-(int)getWidgetid;
-(void)setWidgetid:(int)newWidgetid;

@end
