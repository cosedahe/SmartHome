//
//  CameraService.m
//  SmartHome
//
//  Created by Fang minghua on 14-12-3.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "CameraService.h"

@implementation CameraService

static CameraService *instance = nil;

+(id)getInstance
{
    @synchronized(self) {
        if(instance == nil) {
            //instance = [[[self class] alloc] init]; //   assignment   not   done   here
            //instance = [[super allocWithZone:NULL] init];
            instance = [[CameraService alloc] init];
            instance.cameraId = [[NSString alloc] init];
            instance.user = [[NSString alloc] init];
            instance.pwd = [[NSString alloc] init];
            instance.m_PPPPChannelMgt = new CPPPPChannelManagement();
            instance.m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
        }
    }
    return instance;
}

-(void)Initialize
{
    PPPP_Initialize((char*)[@"EBGBEMBMKGJMGAJPEIGIFKEGHBMCHMJHCKBMBHGFBJNOLCOLCIEBHFOCCHKKJIKPBNMHLHCPPFMFADDFIINOIABFMH" UTF8String]);
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
}

@end
