//
//  UserDao.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseDao.h"
#import "UserBean.h"

@interface UserDao : BaseDao

-(int)add:(UserBean *)bean;
-(void)deleteObj:(UserBean *)bean;
-(void)updateObj:(UserBean *)bean;
-(NSMutableArray *)getAll;
-(UserBean *)getInstanceById:(int)id;
-(NSMutableArray *)getDeviceList:(NSString *)myName;
-(void)deletUserByDeviceNumAndUserName:(long)deviceNum :(NSString *)username;
-(NSMutableArray *)getUsersByName:(NSString *)username; // userbean s
-(int)getIdByDeviceNumber:(NSString *)username :(long)deviceNum;

-(UserBean *)getUserBean:(sqlite3_stmt *)statement;

@end
