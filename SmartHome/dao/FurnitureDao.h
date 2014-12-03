//
//  FurnitureDao.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-18.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseDao.h"
#import "FurnitureBean.h"
#import "SocketMessage.h"

@interface FurnitureDao : BaseDao
{
@private SocketMessage *socketmessage;
}

-(int)add:(FurnitureBean *)bean;
-(void)deleteObj:(FurnitureBean *)bean;
-(void)updateObj:(FurnitureBean *)bean;
-(NSMutableArray *)getAll;
-(FurnitureBean *)getInstanceById:(int)id;
-(NSMutableArray *)getListByFatherId:(int)fatherid;
-(void)deleteByFatherId:(int)fatherId;
-(FurnitureBean *)getAllById:(int)myId;
-(int)getIdByName:(int)myId :(NSString *)myName;
-(FurnitureBean *)getFurnitureByNameAndTagAndFatherId:(NSString *)myName :(NSString *)myTag :(int)fatherId;

@end
