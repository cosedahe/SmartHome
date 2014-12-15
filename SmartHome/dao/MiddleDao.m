//
//  MiddleDao.m
//  SmartHome
//
//  Created by He Teli on 14-11-26.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "MiddleDao.h"

@implementation MiddleDao
-(int)add:(MiddleBean *)bean
{
    [self openDB];
    int id = 0;
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into 't_middle' ('patternid','widgetid') values('%d','%d')",  [bean getPatternid],[bean getWidgetid]];
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

-(void)deleteObj:(MiddleBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_middle where _id = '%d'",[bean getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(void)updateObj:(MiddleBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"update t_middle set patternid='%d',widgetid='%d' where _id = '%d'",[bean getPatternid],[bean getWidgetid],[bean getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(NSMutableArray *)getAll
{
    [self openDB];
    NSMutableArray *middlelist = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from t_middle";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            MiddleBean *bean = [self getMiddleBean:stmt];
            [middlelist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return middlelist;
}

-(MiddleBean *)getInstanceById:(int)id
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_room where t_middle ='%d'",id];
    MiddleBean *bean = nil;
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            bean = [self getMiddleBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return bean;
}

-(NSMutableArray *)getListByFatherId:(int)fatherid
{
    [self openDB];
    NSMutableArray *middlelist = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_middle where widgetid='%d'",fatherid];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            MiddleBean *bean = [self getMiddleBean:stmt];
            [middlelist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return middlelist;
}

-(void)deleteByFatherId:(int)fatherId
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_middle where widgetid = '%d'",fatherId];
    [self execSQL:sql];
    
    [self closeDB];
}

-(void)deleteByFatherIdAndPatternId:(int)fatherId :(int)patternid
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_middle where widgetid = '%d' and patternid='%d'",fatherId,patternid];
    [self execSQL:sql];
    
    [self closeDB];
}

-(NSMutableArray *)getPatternById:(int)pattern
{
    [self openDB];
    NSMutableArray *middlelist = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_middle where patternid='%d'",pattern];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            MiddleBean *bean = [self getMiddleBean:stmt];
            [middlelist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return middlelist;
}

-(NSMutableArray *)getPatternByMiddle:(int)middleid :(int)pattern
{
    [self openDB];
    NSMutableArray *middlelist = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_middle where widgetid='%d' and patternid='%d'",middleid,pattern];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            MiddleBean *bean = [self getMiddleBean:stmt];
            [middlelist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return middlelist;
}

-(MiddleBean *)getMiddleBean:(sqlite3_stmt *)statement
{
    MiddleBean *bean = [[MiddleBean alloc] init];
    [bean setId:sqlite3_column_int(statement, 0)];
    [bean setPatternid:sqlite3_column_int(statement, 1)];
    [bean setWidgetid:sqlite3_column_int(statement, 2)];
    
    return bean;
}


@end
