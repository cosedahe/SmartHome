//
//  SMCameraViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-12-2.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "BaseViewController.h"
#include "PPPP_API.h"
#include "PPPPChannelManagement.h"
#import "ImageNotifyProtocol.h"
#import "SearchCameraResultProtocol.h"
#import "SearchDVS.h"
#import "ParamNotifyProtocol.h"

@interface SMCameraViewController : BaseViewController
@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;
@property CPPPPChannelManagement *m_PPPPChannelMgt;
@property UIImageView *playView;
@property (nonatomic, retain) NSTimer* searchTimer;
@property NSString *_cameraID;
@property NSString *user;
@property NSString *pwd;

@end
