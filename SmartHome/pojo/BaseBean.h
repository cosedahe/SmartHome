//
//  BaseBean.h
//  SmartHome
//
//  Created by He Teli on 14-11-14.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseBean : NSObject
{
@private int beanId;
}

-(int)getId;
-(void)setId:(int)newId;

@end
