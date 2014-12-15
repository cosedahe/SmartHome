//
//  RoomBean.h
//  SmartHome
//
//  Created by He Teli on 14-11-17.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "BaseBean.h"

@interface RoomBean : BaseBean
{
@private NSString *name;
@private NSMutableArray *furniturelist;
@private NSString *userName;
@private long deviceNum;
@private NSString *description;
@private NSString *ImagePath;
}

-(NSString *)getImagePath;
-(void)setImagePath:(NSString *)imagePath;
-(NSString *)getName;
-(void)setName:(NSString *)newName;
-(NSMutableArray *)getFurniturelist;
-(void)setFurniturelist:(NSMutableArray *)list;
-(NSString *)getUserName;
-(void)setUserName:(NSString *)newName;
-(long)getDeviceNum;
-(void)setDeviceNum:(long)newNum;
-(NSString *)getDescription;
-(void)setDescription:(NSString *)newDescription;

@end
