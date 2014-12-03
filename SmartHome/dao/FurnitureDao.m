//
//  FurnitureDao.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-18.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "FurnitureDao.h"

@implementation FurnitureDao

-(id)init
{
    self = [super init];
    
    if(self)
    {
        socketmessage = [SocketMessage getInstance];
    }
    
    return self;
}

-(int)add:(FurnitureBean *)bean
{
    [self openDB];
    int id = 0;
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into 't_furniture' ('roomid','name','tag','downcode','description','lastdo') values('%d','%@','%@','%ld','%@','%@')", [bean getRoomId],[bean getName]!=nil ? [bean getName] : @"name", [bean getTag],[bean getDowncode], [bean getDescription]!=nil ? [bean getDescription] : @"description", [bean getLastdo]!=nil ? [bean getLastdo] : @"无操作"];
    [self execSQL:sql];
    
    sql = @"SELECT max(_id) FROM t_furniture";
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

-(void)deleteObj:(FurnitureBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_furniture where _id = '%d'",[bean getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(void)updateObj:(FurnitureBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"update t_furniture set roomid = '%d' ,name ='%@',tag ='%@',downcode='%ld',description='%@',lastdo='%@' where _id = '%d'",[bean getRoomId],[bean getName],[bean getTag],[bean getDowncode],[bean getDescription],[bean getLastdo],[bean getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(NSMutableArray *)getAll
{
    [self openDB];
    NSMutableArray *furniturelist = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from t_furniture";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            FurnitureBean *bean = [self getFurnitureBean:stmt];
            [furniturelist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return furniturelist;
}

-(FurnitureBean *)getInstanceById:(int)id
{
    return nil;
}

-(NSMutableArray *)getListByFatherId:(int)fatherid
{
    [self openDB];
    NSMutableArray *furniturelist = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_furniture where roomid = '%d'",fatherid];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            FurnitureBean *bean = [self getFurnitureBean:stmt];
            [furniturelist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return furniturelist;
}

-(void)deleteByFatherId:(int)fatherId
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_furniture where roomid = '%d'",fatherId];
    [self execSQL:sql];
    
    [self closeDB];
}

-(FurnitureBean *)getAllById:(int)myId
{
    [self openDB];
    FurnitureBean *bean = [[FurnitureBean alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_furniture where _id = '%d'",myId];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            bean = [self getFurnitureBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return bean;
}

-(int)getIdByName:(int)myId :(NSString *)myName
{
    int myRoomId = 0;
    
    [self openDB];
    NSString *sql = [[NSString alloc] initWithFormat:@"select roomid from t_furniture where roomid ='%d' and name = '%@'", myId, myName];
    
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            myRoomId = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return myRoomId;
}

-(FurnitureBean *)getFurnitureByNameAndTagAndFatherId:(NSString *)myName :(NSString *)myTag :(int)fatherId
{
    [self openDB];
    FurnitureBean *bean = [[FurnitureBean alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_furniture where name = '%@' and tag='%@' and roomid = '%d'",myName, myTag, fatherId];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            bean = [self getFurnitureBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return bean;
}

-(FurnitureBean *)getFurnitureBean:(sqlite3_stmt *)statement
{
    FurnitureBean *bean = [[FurnitureBean alloc] init];
    [bean setId:sqlite3_column_int(statement, 0)];
    [bean setRoomId:sqlite3_column_int(statement, 1)];
    [bean setName:[[NSString alloc] initWithUTF8String:sqlite3_column_text(statement, 2)]];
    [bean setTag:[[NSString alloc] initWithUTF8String:sqlite3_column_text(statement, 3)]];
    [bean setDowncode:sqlite3_column_int64(statement, 4)];
    [bean setDescription:[[NSString alloc] initWithUTF8String:sqlite3_column_text(statement, 5)]];
    [bean setLastdo:[[NSString alloc] initWithUTF8String:sqlite3_column_text(statement, 6)]];
    
    return bean;
}

@end
