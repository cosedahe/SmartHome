//
//  MiddleDao.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-26.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseDao.h"
#import "MiddleBean.h"

@interface MiddleDao : BaseDao

-(int)add:(MiddleBean *)bean;
-(void)deleteObj:(MiddleBean *)bean;
-(void)updateObj:(MiddleBean *)bean;
-(NSMutableArray *)getAll;
-(MiddleBean *)getInstanceById:(int)id;
-(NSMutableArray *)getListByFatherId:(int)fatherid;
-(void)deleteByFatherId:(int)fatherId;
-(void)deleteByFatherIdAndPatternId:(int)fatherId :(int)patternid;
-(NSMutableArray *)getPatternById:(int)pattern;
-(NSMutableArray *)getPatternByMiddle:(int)middleid :(int)pattern;

@end
