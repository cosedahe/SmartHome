//
//  BaseDao.h
//  SmartHome
//
//  Created by He Teli on 14-11-14.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DATABASE_NAME @"/furniture.sqlite" //@"furniture.db"

@interface BaseDao : NSObject
{
    sqlite3 *db;
}

-(BOOL)openDB;
-(void)closeDB;
-(void)execSQL:(NSString *)sql;
-(void)onCreate;
-(int)add;

@end
