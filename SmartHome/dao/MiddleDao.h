//
//  MiddleDao.h
//  SmartHome
//
//  Created by He Teli on 14-11-26.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
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
