//
//  BaseDao.m
//  SmartHome
//
//  Created by He Teli on 14-11-14.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "BaseDao.h"

@implementation BaseDao
static bool isCreated = false;

-(BOOL)openDB
{
    if(db != nil)
        return YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc = [paths lastObject];
    NSString *database_path = [doc stringByAppendingString:DATABASE_NAME];
    //NSString *database_path = [];
    // NSLog(@"%@", database_path);
    
    int ret = -1;
    if((ret = sqlite3_open([database_path UTF8String], &db)) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"Open database failed！ret = %d, databasepath = %@", ret, database_path);
        return NO;
    }
    [self onCreate];
    return YES;
}

-(void)execSQL:(NSString *)sql
{
    char errmsg[1024];
    int ret;
    if((ret = sqlite3_exec(db, [sql UTF8String], nil, nil, &errmsg)) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"ret = %d", ret);
        NSLog(@"Error Message:%@", [[NSString alloc] initWithCString:errmsg encoding:NSUTF8StringEncoding]);
        NSLog(@"Database handling error! SQL:%@", sql);
    }
}

-(void)onCreate
{
    if (!isCreated)
    {
    NSString *sql = @"create table IF NOT EXISTS t_middle (_id integer primary key autoincrement,patternid integer,widgetid integer)";
    [self execSQL:sql];
    sql = @"create table IF NOT EXISTS t_furniture (_id integer primary key autoincrement,roomid integer,name varchar(20) default ('name'),tag varchar(20),downcode long,description varchar(20) default ('description'),lastdo varchar(20) default ('last do'))";
    [self execSQL:sql];
    sql = @"create table IF NOT EXISTS t_pattern (_id integer primary key autoincrement,name varchar(20) default ('name'),userid integer,description varchar(20) default ('description'),devicenum long,imagePath varchar(50))";
    [self execSQL:sql];
    sql = @"create table IF NOT EXISTS t_room (_id integer primary key autoincrement,name varchar(20),username varchar(20) default ('username'),devicenumber long,description varchar(20) default ('description'),imagepath varchar(50) default('path'))";
    [self execSQL:sql];
    sql = @"create table IF NOT EXISTS t_user (_id integer primary key autoincrement,name varchar(20),device_number long)";
    [self execSQL:sql];
    sql = @"create table IF NOT EXISTS t_widget (_id integer primary key autoincrement,furnitureid integer,downcode long,tag varchar(20),widgetid long,status integer)";
    [self execSQL:sql];
    sql = @"create table IF NOT EXISTS t_mark (_id integer primary key autoincrement,widgetid integer,mark integer)";
    [self execSQL:sql];
    sql = @"create table IF NOT EXISTS t_air (_id integer primary key autoincrement,name varchar(20),downcode integer,tmp varchar(20),windspeed varchar(20),model varchar(20),furnitureid integer,study integer)";
    [self execSQL:sql];
    sql = @"create table IF NOT EXISTS t_clock (_id integer primary key autoincrement,week varchar(20),starttime varchar(20),furnitureid integer,repetition integer,start integer)";
    [self execSQL:sql];
        isCreated = true;
    }
}

-(void)closeDB
{
    if (db == nil)
        return;
    sqlite3_close(db);
    db = nil;
}

@end
