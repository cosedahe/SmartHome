//
//  CameraService.m
//  SmartHome
//
//  Created by Fang minghua on 14-12-3.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "CameraService.h"

@implementation CameraService
@synthesize cameraId;
@synthesize user;
@synthesize roomId;
@synthesize pwd;

static CameraService *instance = nil;

+(id)getInstance
{
    @synchronized(self) {
        if(instance == nil) {
            //instance = [[[self class] alloc] init]; //   assignment   not   done   here
            //instance = [[super allocWithZone:NULL] init];
            instance = [[self alloc] init];
            instance.cameraId = @"";
            instance.user = @"";
            instance.pwd = @"";
            instance->_m_PPPPChannelMgt = new CPPPPChannelManagement();
            instance->_m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
            instance->_defaults = [NSUserDefaults standardUserDefaults];
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

-(NSString *)cameraId
{
    if([cameraId isEqualToString:@""])
    {
        cameraId = [instance->_defaults objectForKey:CAM_ID];
    }
    
    if([cameraId isEqual:nil] || cameraId == nil)
        cameraId = @"";
    return cameraId;
}

-(void)setCameraId:(NSString *)newCameraId
{
    cameraId = newCameraId;
    [instance->_defaults setObject:cameraId forKey:CAM_ID];
    [instance->_defaults synchronize];
}

-(NSString *)user
{
    if([user isEqualToString:@""])
    {
        user = [instance->_defaults objectForKey:CAM_USER];
    }
    if([user isEqual:nil])
        user = @"";
    return user;
}

-(void)setUser:(NSString *)newUser
{
    user = newUser;
    [instance->_defaults setObject:user forKey:CAM_USER];
    [instance->_defaults synchronize];
}

-(NSString *)pwd
{
    if([pwd isEqualToString:@""])
    {
        pwd = [instance->_defaults objectForKey:CAM_PWD];
    }
    if([pwd isEqual:nil])
        pwd = @"";
        
    return pwd;
}

-(void)setPwd:(NSString *)newPwd
{
    pwd = newPwd;
    [instance->_defaults setObject:pwd forKey:CAM_PWD];
    [instance->_defaults synchronize];
}

-(void)stop
{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    [_m_PPPPChannelMgtCondition unlock];
}

@end
