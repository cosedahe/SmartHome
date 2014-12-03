//
//  RoomDao.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseDao.h"
#import "RoomBean.h"
#import "SocketMessage.h"

@interface RoomDao : BaseDao
{
@private SocketMessage *mySocketMessage;
}

-(int)add:(RoomBean *)room;
-(void)deleteObj:(RoomBean *)room;
-(void)updateObj:(RoomBean *)room;
-(NSMutableArray *)getAll;
-(RoomBean *)getInstanceById:(int)id;
-(NSMutableArray *)getRoomListByUserName:(NSString *)name;
-(NSMutableArray *)getRoomListByPatternid:(int)pId;
-(NSMutableArray *)getRoomListByUserNameAndDeviceNumber:(NSString *)username :(long)deviceNum;
-(void)deleteRoomByUserNameAndDeviceNumber:(NSString *)username :(long)deviceNum;
-(RoomBean *)getUpCodeByRoomName:(long)UpCode;
-(int)getNameById:(NSString *)myName;
-(void)getTable;
-(RoomBean *)getRoomBean:(sqlite3_stmt *)statement;

@end
