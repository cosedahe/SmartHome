//
//  UserBean.h
//  SmartHome
//
//  Created by He Teli on 14-11-14.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "BaseBean.h"

@interface UserBean : BaseBean
{
@private NSString *name;
@private long device_number;
@private NSMutableArray *devices;
}

-(NSString *)getName;
-(void)setName:(NSString *)newName;
-(long)getDevice_number;
-(void)setDevice_number:(long)newNumber;
-(NSMutableArray *)getDeices;   // store devices' numbers
-(void)setDevices:(NSMutableArray *)newDevices;


@end
