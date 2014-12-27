//
//  AirDao.m
//  SmartHome
//
//  Created by He Teli on 14-11-25.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "AirDao.h"

@implementation AirDao

-(id)init
{
    self = [super init];
    
    if(self)
    {
        socketmessage = [SocketMessage getInstance];
    }
    
    return self;
}

-(int)add:(AirBean *)bean
{
    [self openDB];
    int id = 0;
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into 't_air' ('name','downcode','tmp','windspeed','model','furnitureid') values('%@','%ld','%@','%@','%@','%d')",  [bean getName],[bean getDowncode], [bean getTemp], [bean getWindspeed], [bean getModel], [bean getFurnitureid]];
    [self execSQL:sql];
    
    sql = @"SELECT max(_id) FROM t_air";
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

-(void)deleteObj:(AirBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_air where _id = '%d'",[bean getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(void)updateObj:(AirBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"update t_air set name = '%@', downcode ='%ld',tmp='%@',windspeed='%@',model='%@',furnitureid='%d' where _id = '%d'",[bean getName],[bean getDowncode],[bean getTemp],[bean getWindspeed],[bean getModel],[bean getFurnitureid], [bean getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(NSMutableArray *)getAll
{
    [self openDB];
    NSMutableArray *widgetlist = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from t_air";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            AirBean *bean = [self getAirBean:stmt];
            [widgetlist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return widgetlist;
}

-(AirBean *)getInstanceById:(int)id
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_room where t_air ='%d'",id];
    AirBean *bean = nil;
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            bean = [self getAirBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return bean;
}

-(NSMutableArray *)getListByFatherId:(int)fatherid
{
    [self openDB];
    NSMutableArray *airlist = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_air where furnitureid = '%d'",fatherid];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            AirBean *bean = [self getAirBean:stmt];
            [airlist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return airlist;
}

-(void)deleteByFatherId:(int)fatherId
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_air where furnitureid = '%d'",fatherId];
    [self execSQL:sql];
    
    [self closeDB];
}

-(long)getMaxDownCode
{
    [self openDB];
    long maxDowncode = 0;
    
    NSString *sql = @"SELECT max(downcode) FROM t_air";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            maxDowncode = sqlite3_column_int64(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return maxDowncode;
}

-(long)getDownCodeById:(int)myDownCode
{
    long downcode = 0;
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT * FROM t_air where downcode='%d'", myDownCode];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            downcode = sqlite3_column_int64(stmt, 2);
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return downcode;
}

-(int)selectNameById:(AirBean *)bean
{
    int myId = 0;
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT * FROM t_air where tmp='%@' and model='%@' and windspeed='%@' and furnitureid='%d'", [bean getTemp], [bean getModel], [bean getWindspeed], [bean getFurnitureid]];
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

-(long)getDownCodeByBean:(AirBean *)bean
{
    long myCode = 0;
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT * FROM t_air where tmp='%@' and model='%@' and windspeed='%@' and furnitureid='%d'", [bean getTemp], [bean getModel], [bean getWindspeed], [bean getFurnitureid]];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            myCode = sqlite3_column_int(stmt, 2);
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return myCode;
}

-(AirBean *)getAirBean:(sqlite3_stmt *)statement
{
    AirBean *bean = [[AirBean alloc] init];
    [bean setId:sqlite3_column_int(statement, 0)];
    [bean setName:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
    [bean setDowncode:sqlite3_column_int64(statement, 2)];
    [bean setTmp:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
    [bean setWindspeed:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
    [bean setModel:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
    [bean setFurnitureid:sqlite3_column_int(statement, 6)];
    [bean setStudy:sqlite3_column_int(statement, 7)];
    
    return bean;
}

@end
