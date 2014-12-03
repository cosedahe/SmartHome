//
//  UserDao.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "UserDao.h"

@implementation UserDao

-(int)add:(UserBean *)bean
{
    [self openDB];
    int id = 0;
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into 't_user'('name','device_number') values('%@','%ld')", [bean getName], [bean getDevice_number]];
    [super execSQL:sql];
    
    sql = @"SELECT max(_id) FROM t_user";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            // 1 or 0 ????????
            id = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return id;
}

-(void)deleteObj:(UserBean *)bean
{
    [self openDB];
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_user where _id = '%d'", [bean getId]];
    [super execSQL:sql];
    [self closeDB];
}

-(void)updateObj:(UserBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"update t_user set name = '%@' ,device_number ='%ld' where _id = '%d'", [bean getName], [bean getDevice_number], [bean getId]];
    [super execSQL:sql];
    
    [self closeDB];
}

-(NSMutableArray *)getAll
{
    [self openDB];
    
    NSMutableArray *userlist = [[NSMutableArray alloc] init];
    NSString *sql = @"select * from t_user";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            UserBean *user = [self getUserBean:stmt];
            [userlist addObject:user];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return userlist;
}

-(UserBean *)getInstanceById:(int)id
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_user where _id ='%d'",id];
    UserBean *user = nil;
    
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            user = [self getUserBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return user;
}

// data type is long
-(NSMutableArray *)getDeviceList:(NSString *)myName
{
    [self openDB];
    
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select device_number from t_user where name = '%@'", myName];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            [devices addObject:[NSNumber numberWithLong:sqlite3_column_int64(stmt, 0)]];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return devices;
}

-(void)deletUserByDeviceNumAndUserName:(long)deviceNum :(NSString *)username
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_user where device_number = '%ld' and name='%@'", deviceNum, username];
    [super execSQL:sql];
    
    [self closeDB];
}

-(NSMutableArray *)getUsersByName:(NSString *)username
{
    [self openDB];
    
    NSMutableArray *users = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_user where name = '%@'", username];
    sqlite3_stmt *stmt;

    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            UserBean *user = [self getUserBean:stmt];
            [users addObject:user];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return users;
}

-(int)getIdByDeviceNumber:(NSString *)username :(long)deviceNum
{
    [self openDB];
    
    int id = 0;
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_user where device_number = '%ld' and name='%@'", deviceNum, username];
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

-(UserBean *)getUserBean:(sqlite3_stmt *)statement
{
    UserBean *userBean = [[UserBean alloc] init];
    [userBean setId:sqlite3_column_int(statement, 0)];
    [userBean setName:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
    [userBean setDevice_number:sqlite3_column_int64(statement, 2)];
    
    return userBean;
}

@end
