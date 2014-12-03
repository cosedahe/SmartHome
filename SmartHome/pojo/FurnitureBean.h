//
//  FurnitureBean.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-18.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseBean.h"

#define LIGHT @"light"
#define TELEVISION @"television"
#define AIRCONDITION @"aircondition"
#define CAMERA @"camera"
#define ALARMBELL @"alarmbell"
#define CURTAIN @"curtain"
#define OUTLET @"outlet"
#define BACKGROUNDMUSIC @"backgroundmusic"

@interface FurnitureBean : BaseBean
{
@private int roomId;
@private NSString *name;
@private NSString *tag;
    //自身控件的ID号
@private long downcode;
@private NSString *description;
@private NSString *lastdo;  // 最后一次操作
@private NSMutableArray *widgetlist;    // WidgetBean
}

-(NSString *)getLastdo;
-(void)setLastdo:(NSString *)doing;
-(NSString *)getDescription;
-(void)setDescription:(NSString *)newDescription;
-(int)getRoomId;
-(void)setRoomId:(int)newRoomId;
-(NSString *)getName;
-(void)setName:(NSString *)newName;
-(NSString *)getTag;
-(void)setTag:(NSString *)newTag;
-(long)getDowncode;
-(void)setDowncode:(long)newCode;
-(NSMutableArray *)getWidgetlist;
-(void)setWidgetlist:(NSMutableArray *)newlist;

@end
