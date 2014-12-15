//
//  AirDao.h
//  SmartHome
//
//  Created by He Teli on 14-11-25.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
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
