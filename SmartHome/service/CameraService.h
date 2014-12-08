//
//  CameraService.h
//  SmartHome
//
//  Created by Fang minghua on 14-12-3.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPP_API.h"
#import "PPPPChannelManagement.h"
#import "ImageNotifyProtocol.h"
#import "SearchCameraResultProtocol.h"
#import "SearchDVS.h"
#import "ParamNotifyProtocol.h"

#define CAM_ID @"camera_id"
#define CAM_USER @"camera_user"
#define CAM_PWD @"camera_password"

@interface CameraService : NSObject


@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;
@property CPPPPChannelManagement *m_PPPPChannelMgt;
@property (nonatomic)  NSString *cameraId;
@property (nonatomic)  NSString *user;
@property (nonatomic)  NSString *pwd;
@property (nonatomic)  NSString *roomId;
@property (nonatomic)  NSUserDefaults *defaults;

+(id)getInstance;
-(void)Initialize;
-(void)stop;

@end
