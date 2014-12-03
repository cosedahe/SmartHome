//
//  BaseBean.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-14.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseBean : NSObject
{
@private int beanId;
}

-(int)getId;
-(void)setId:(int)newId;

@end
