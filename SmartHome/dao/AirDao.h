//
//  AirDao.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-25.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseDao.h"
#import "SocketMessage.h"
#import "AirBean.h"

@interface AirDao : BaseDao
{
@private SocketMessage *socketmessage;
}

-(int)add:(AirBean *)bean;
-(void)deleteObj:(AirBean *)bean;
-(void)updateObj:(AirBean *)bean;
-(NSMutableArray *)getAll;
-(AirBean *)getInstanceById:(int)id;
-(NSMutableArray *)getListByFatherId:(int)fatherid;
-(void)deleteByFatherId:(int)fatherId;
-(long)getDownCodeById:(int)myDownCode;
-(int)selectNameById:(AirBean *)bean;
-(long)getDownCodeByBean:(AirBean *)bean;

@end
