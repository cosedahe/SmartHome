//
//  RoomDao.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "RoomDao.h"

@implementation RoomDao

-(id)init
{
    self = [super init];
    
    if(self)
    {
        mySocketMessage = [SocketMessage getInstance];
    }
    
    return self;
}

-(int)add:(RoomBean *)room
{
    [self openDB];
    int id = 0;
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into 't_room' ('name','username','devicenumber','description','imagepath') values('%@','%@','%ld','%@','%@')", [room getName]!=nil ? [room getName] : @"name",[room getUserName], [room getDeviceNum], [room getDescription]!=nil ? [room getDescription] : @"description", [room getImagePath]];
    [self execSQL:sql];
    
    sql = @"SELECT max(_id) FROM t_room";
    sqlite3_stmt *stmt;
    
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            id = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return id;
}

-(void)deleteObj:(RoomBean *)room
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_room where _id = '%d'",[room getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(void)updateObj:(RoomBean *)room
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"update t_room set name = '%@' ,username ='%@',devicenumber ='%ld',description='%@',imagepath='%@' where _id = '%d'",[room getName],[room getUserName],[room getDeviceNum],[room getDescription],[room getImagePath],[room getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(NSMutableArray *)getAll
{
    [self openDB];
    NSMutableArray *roomlist = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from t_room";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            RoomBean *room = [self getRoomBean:stmt];
            [roomlist addObject:room];
        }
        sqlite3_finalize(stmt);
    }

    [self closeDB];
    return roomlist;
}

-(RoomBean *)getInstanceById:(int)id
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_room where _id ='%d'",id];
    RoomBean *roombean = nil;
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            roombean = [self getRoomBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return roombean;
}

-(NSMutableArray *)getRoomListByUserName:(NSString *)name
{
    [self openDB];
    
    NSMutableArray *roomlist = [[NSMutableArray alloc] init];
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_room where username='%@'",name];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            RoomBean *room = [self getRoomBean:stmt];
            [roomlist addObject:room];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return roomlist;
}

-(NSMutableArray *)getRoomListByPatternid:(int)pId
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_room where _id='%d'",pId];
    NSMutableArray *roomlist = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            RoomBean *room = [self getRoomBean:stmt];
            [roomlist addObject:room];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return roomlist;
}

-(NSMutableArray *)getRoomListByUserNameAndDeviceNumber:(NSString *)username :(long)deviceNum
{
    [self openDB];
    
    NSMutableArray *roomlist = [[NSMutableArray alloc] init];
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_room where username='%@' and devicenumber='%ld'",username, deviceNum];
    NSLog(@"SQL:%@", sql);
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            RoomBean *room = [self getRoomBean:stmt];
            [roomlist addObject:room];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return roomlist;
}

-(void)deleteRoomByUserNameAndDeviceNumber:(NSString *)username :(long)deviceNum
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_room where username='%@' and devicenumber='%ld'",username, deviceNum];
    [self execSQL:sql];
    
    [self closeDB];
}

-(RoomBean *)getUpCodeByRoomName:(long)UpCode
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_room where _id = (select roomid from t_furniture where _id = (select furnitureid from t_widget where downcode = '%d'))",UpCode];
    RoomBean *roombean = nil;
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            roombean = [self getRoomBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return roombean;
}

-(int)getNameById:(NSString *)myName
{
    [self openDB];
    
    int myId = 0;
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_room where name='%@' and devicenumber='%ld'",myName, [mySocketMessage getServerid]];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            myId = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return myId;
}

-(void)getTable
{
    [self openDB];
    
    NSString *sql = @"alter table user add image varchar(20)";
    [self execSQL:sql];
    
    [self closeDB];
}

-(RoomBean *)getRoomBean:(sqlite3_stmt *)statement
{
    RoomBean *roomBean = [[RoomBean alloc] init];
    [roomBean setId:sqlite3_column_int(statement, 0)];
    [roomBean setName:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
    [roomBean setUserName:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
    [roomBean setDeviceNum:sqlite3_column_int64(statement, 3)];
    [roomBean setDescription:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
    [roomBean setImagePath:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
    
    return roomBean;
}


@end
