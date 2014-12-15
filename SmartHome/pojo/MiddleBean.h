//
//  MiddleBean.h
//  SmartHome
//
//  Created by He Teli on 14-11-26.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
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
