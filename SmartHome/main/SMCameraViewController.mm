//
//  SMCameraViewController.m
//  SmartHome
//
//  Created by Fang minghua on 14-12-2.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SMCameraViewController.h"
#include "MyAudioSession.h"
#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"

#import "SearchDVS.h"

@interface SMCameraViewController ()

@end

@implementation SMCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._cameraID = @"VSTC273012LSKSS";
    self.user = @"admin";
    self.pwd = @"888888";
    _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
    _m_PPPPChannelMgt = new CPPPPChannelManagement();
    _m_PPPPChannelMgt->pCameraViewController = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)initialize
{
    PPPP_Initialize((char*)[@"EBGBEMBMKGJMGAJPEIGIFKEGHBMCHMJHCKBMBHGFBJNOLCOLCIEBHFOCCHKKJIKPBNMHLHCPPFMFADDFIINOIABFMH" UTF8String]);
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
}

-(void)connectCamera
{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    dispatch_async(dispatch_get_main_queue(),^{
        self.playView.image = nil;
    });
    
    self._cameraID = @"VSTC273012LSKSS";
    
    [self performSelector:@selector(startPPPP:) withObject:self._cameraID];
    [_m_PPPPChannelMgtCondition unlock];
}

- (void) startPPPP:(NSString*) camID{
#warning secrect code
    _m_PPPPChannelMgt->Start([camID UTF8String], [@"admin" UTF8String], [@"888888" UTF8String]);
}

@end
