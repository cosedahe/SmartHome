//
//  WidgetDao.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-19.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "WidgetDao.h"

@implementation WidgetDao

-(id)init
{
    self = [super init];
    
    if(self)
    {
        socketmessage = [SocketMessage getInstance];
    }
    
    return self;
}

-(int)add:(WidgetBean *)bean
{
    [self openDB];
    int id = 0;
    NSString *sql = [[NSString alloc] initWithFormat:@"insert into 't_widget' ('furnitureid','downcode','tag','widgetid','status') values('%d','%ld','%@','%ld','%d')", [bean getFurnitureId],[bean getDowncode], [bean getTag],[bean getWidgetid], [bean getStatus]];
    [self execSQL:sql];
    
    sql = @"SELECT max(_id) FROM t_widget";
    sqlite3_stmt *stmt;
    
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            id = sqlite3_column_int(stmt, 0);
            sqlite3_finalize(stmt);
            if(id != 0)
            {
                NSString *sql2;
                // 把控件发送代码的类型保存下来，如果是2的话就发送downcode，如果是1，则发送curtaincode，在情景模式中被调用
                if([[bean getTag] isEqualToString:CURTAIN])
                {
                    sql2 = [[NSString alloc] initWithFormat:@"insert into 't_mark'('widgetid', 'mark') values('%d','%d')", id, 1];
                }
                else if([[bean getTag] isEqualToString:LIGHT] || [[bean getTag] isEqualToString:TELEVISION] || [[bean getTag] isEqualToString:AIRCONDITION] || [[bean getTag] isEqualToString:OUTLET] || [[bean getTag] isEqualToString:BACKGROUNDMUSIC])
                {
                    sql2 = [[NSString alloc] initWithFormat:@"insert into 't_mark'('widgetid', 'mark') values('%d','%d')", id, 2];
                }
                [self execSQL:sql2];
            }
        }
    }
    
    [self closeDB];
    return id;
}

-(void)deleteObj:(WidgetBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_widget where _id = '%d'",[bean getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(void)updateObj:(WidgetBean *)bean
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"update t_widget set furnitureid = '%d', tag ='%@',downcode='%ld',widgetid='%ld',status='%d' where _id = '%d'",[bean getFurnitureId],[bean getTag],[bean getDowncode],[bean getWidgetid],[bean getStatus],[bean getId]];
    [self execSQL:sql];
    
    [self closeDB];
}

-(NSMutableArray *)getAll
{
    [self openDB];
    NSMutableArray *widgetlist = [[NSMutableArray alloc] init];
    
    NSString *sql = @"select * from t_widget";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            WidgetBean *bean = [self getWidgetBean:stmt];
            [widgetlist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return widgetlist;
}

-(WidgetBean *)getInstanceById:(int)id
{
    return  nil;
}

-(long)getMaxDownCode
{
    [self openDB];
    long maxDowncode = 0;
    
    NSString *sql = @"SELECT max(downcode) FROM t_widget";
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

-(long)getDownCodeByWidgetId:(int)widgetid
{
    long downcode = 0;
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT max(downcode) FROM t_widget where _id='%d'", widgetid];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            downcode = [[self getWidgetBean:stmt] getDowncode];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return downcode;
}

-(NSMutableArray *)getListByFatherId:(int)fatherid
{
    [self openDB];
    NSMutableArray *widgetlist = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_widget where furnitureid = '%d'",fatherid];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            WidgetBean *bean = [self getWidgetBean:stmt];
            [widgetlist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return widgetlist;
}

-(NSMutableArray *)getListByFatherIdAndWIdgetId:(int)fatherid :(int)widgetid
{
    [self openDB];
    NSMutableArray *widgetlist = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_widget where furnitureid = '%d' and widgetid='%d'",fatherid,widgetid];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            WidgetBean *bean = [self getWidgetBean:stmt];
            [widgetlist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return widgetlist;
}

-(void)deleteByFatherId:(int)fatherId
{
    [self openDB];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"delete from t_widget where furnitureid = '%d'",fatherId];
    [self execSQL:sql];
    
    [self closeDB];
}

-(WidgetBean *)getWighetById:(int)myId
{
    [self openDB];
    WidgetBean *bean = [[WidgetBean alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_widget where _id = '%d'",myId];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            bean = [self getWidgetBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return bean;
}

-(NSMutableArray *)getListByTag:(NSString *)myTag
{
    [self openDB];
    NSMutableArray *widgetlist = [[NSMutableArray alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_widget where tag = '%@'",myTag];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            WidgetBean *bean = [self getWidgetBean:stmt];
            [widgetlist addObject:bean];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return widgetlist;
}

-(WidgetBean *)getIdByDownCode:(long)myCode
{
    [self openDB];
    WidgetBean *bean = [[WidgetBean alloc] init];
    
    NSString *sql = [[NSString alloc] initWithFormat:@"select * from t_widget where downcode = '%ld'",myCode];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        if(sqlite3_step(stmt) == SQLITE_ROW)
        {
            bean = [self getWidgetBean:stmt];
        }
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    return bean;
}

-(WidgetBean *)getWidgetBean:(sqlite3_stmt *)statement
{
    WidgetBean *bean = [[WidgetBean alloc] init];
    [bean setId:sqlite3_column_int(statement, 0)];
    [bean setFurnitureId:sqlite3_column_int(statement, 1)];
    [bean setDowncode:sqlite3_column_int64(statement, 2)];
    [bean setTag:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
    [bean setWidgetid:sqlite3_column_int64(statement, 4)];
    [bean setStatus:sqlite3_column_int(statement, 5)];
    
    return bean;
}


-(long)getValidMaxdowncode
{
    
    long maxdowncode = [self getMaxDownCode];
    // there is no downcode in database if it is first loaded
    if(maxdowncode == 0)
    {
#warning TODO: modify maxdowncode
        maxdowncode = 4000;
    }
    
    return maxdowncode;
    /*
     double UnixTime = [[NSDate date] timeIntervalSince1970] * 1000;
     
     // unsigned long long UnixTime = time(NULL);
     long maxdowncode = (unsigned long long)UnixTime % 300001;
     //if(maxdowncode >=1 && maxdowncode <=6 * 10000)
     return maxdowncode;
     //else
     //    return [self getMaxdowncode];
     */
}

@end
