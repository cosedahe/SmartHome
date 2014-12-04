//
//  SMPlayViewController.m
//  SmartHome
//
//  Created by Fang minghua on 14-12-3.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SMPlayViewController.h"
#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"

//#define SHOULD_STOP

@interface SMPlayViewController ()

@end

@implementation SMPlayViewController

-(void)viewDidAppear:(BOOL)animated
{
    if([_cameraservice.cameraId isEqualToString:@""] || [_cameraservice.user isEqualToString:@""] || [_cameraservice.pwd isEqualToString:@""])
    {
        [_cameraservice.m_PPPPChannelMgtCondition lock];
        if (_cameraservice.m_PPPPChannelMgt == NULL) {
            [_cameraservice.m_PPPPChannelMgtCondition unlock];
            [self dismissModalViewControllerAnimated:NO];
            return;
        }
        _cameraservice.m_PPPPChannelMgt->StopAll();
        [_cameraservice.m_PPPPChannelMgtCondition unlock];
        [self dismissModalViewControllerAnimated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cameraservice = [CameraService getInstance];
    _cameraservice.m_PPPPChannelMgt->pCameraViewController = self;
#ifndef SHOULD_STOP
    [NSThread detachNewThreadSelector:@selector(startPlay) toTarget:self withObject:nil];
#endif
    
    // Do any additional setup after loading the view.
}

-(void)startPlay
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    _progress.delegate = self;
    _progress.labelText = @"正在连接...";
    [self.view bringSubviewToFront:_progress];
    _progress.removeFromSuperViewOnHide = YES;
    [_progress show:YES];
    
    [_cameraservice Initialize];
    [self performSelector:@selector(ConnectCam) withObject:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
#ifdef SHOULD_STOP
    [NSThread detachNewThreadSelector:@selector(startPlay) toTarget:self withObject:nil];
#endif
}

-(void)viewWillDisappear:(BOOL)animated
{
#ifdef SHOULD_STOP
    [self stopPlay];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)stopPlay
{
    _cameraservice.m_PPPPChannelMgt->StopPPPPLivestream([_cameraservice.cameraId UTF8String]);
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
    [_cameraservice.m_PPPPChannelMgtCondition lock];
    if (_cameraservice.m_PPPPChannelMgt == NULL) {
        [_cameraservice.m_PPPPChannelMgtCondition unlock];
        return;
    }
    _cameraservice.m_PPPPChannelMgt->StopAll();
    [_cameraservice.m_PPPPChannelMgtCondition unlock];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//ImageNotifyProtocol
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did{
    if(_progress)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [_progress removeFromSuperview];
        // [_progress release];
        _progress = nil;
    }
    [self performSelector:@selector(refreshImage:) withObject:image];
}
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{
    UIImage* image = [APICommon YUV420ToImage:yuv width:width height:height];
    [self performSelector:@selector(refreshImage:) withObject:image];
}
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
}

//refreshImage
- (void) refreshImage:(UIImage* ) image{
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(),^{
            _playView.image = image;
        });
    }
}

#pragma mark -
#pragma mark ParamNotifyProtocol
- (void) ParamNotify: (int) paramType params:(void*) params{
    if (paramType == CGI_IEGET_CAM_PARAMS) {
        PSTRU_CAMERA_PARAM param = (PSTRU_CAMERA_PARAM) params;
        flip = param->flip;
    }
}

- (void)starVideo{
    [NSThread sleepForTimeInterval:5];
    if (_cameraservice.m_PPPPChannelMgt != NULL) {
        if (_cameraservice.m_PPPPChannelMgt->StartPPPPLivestream([_cameraservice.cameraId UTF8String], 10, self) == 0) {
            _cameraservice.m_PPPPChannelMgt->StopPPPPAudio([_cameraservice.cameraId UTF8String]);
            _cameraservice.m_PPPPChannelMgt->StopPPPPLivestream([_cameraservice.cameraId UTF8String]);
        }
        
        _cameraservice.m_PPPPChannelMgt->GetCGI([_cameraservice.cameraId UTF8String], CGI_IEGET_CAM_PARAMS);
    }
    
    [self.playView setHidden:NO];
}

- (void)ConnectCam{
    [_cameraservice.m_PPPPChannelMgtCondition lock];
    
    if (_cameraservice.m_PPPPChannelMgt == NULL) {
        [_cameraservice.m_PPPPChannelMgtCondition unlock];
        return;
    }
    _cameraservice.m_PPPPChannelMgt->StopAll();
    
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
    
    [self performSelector:@selector(startPPPP) withObject:nil];
    [_cameraservice.m_PPPPChannelMgtCondition unlock];

}

- (void) startPPPP{
    _cameraservice.m_PPPPChannelMgt->Start([_cameraservice.cameraId UTF8String], [_cameraservice.user UTF8String], [_cameraservice.pwd UTF8String]);
    [NSThread detachNewThreadSelector:@selector(starVideo) toTarget:self withObject:nil];
}

//PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    
    switch (status) {
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            // store cameraid user & pwd
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:_cameraservice.cameraId forKey:CAM_ID];
            [defaults setObject:_cameraservice.user forKey:CAM_USER];
            [defaults setObject:_cameraservice.pwd forKey:CAM_PWD];
            [defaults synchronize];
        }
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            alertView.message = @"相机已断断线";
            [alertView show];
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            if(_progress)
            {
                [_progress removeFromSuperview];
                // [_progress release];
                _progress = nil;
            }
            alertView.message = @"摄像头ID不正确！";
            [alertView show];
            break;
        case PPPP_STATUS_UNKNOWN:
        case PPPP_STATUS_CONNECT_FAILED:
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
        case PPPP_STATUS_CONNECT_TIMEOUT:
            if(_progress)
            {
                [_progress removeFromSuperview];
                // [_progress release];
                _progress = nil;
            }
            alertView.message = @"连接失败";
            [alertView show];
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            if(_progress)
            {
                [_progress removeFromSuperview];
                //[_progress release];
                _progress = nil;
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            }
            alertView.message = @"用户名密码不正确！";
            [alertView show];
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    NSLog(@"PPPPStatus  %d",status);
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    // remove hud from screen when the hud was hidded
    [hud removeFromSuperview];
    // [hud release];
    hud = nil;
}

- (IBAction)btn_up_onClick:(id)sender {
    /*摄像机需在线状态*/
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([_cameraservice.cameraId UTF8String], CMD_PTZ_UP);
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([_cameraservice.cameraId UTF8String], CMD_PTZ_UP_STOP);
}

- (IBAction)btn_down_onClick:(id)sender {
    /*摄像机需在线状态*/
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([_cameraservice.cameraId UTF8String], CMD_PTZ_DOWN);
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([_cameraservice.cameraId UTF8String], CMD_PTZ_DOWN_STOP);
}

- (IBAction)btn_left_onClick:(id)sender {
    /*摄像机需在线状态*/
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([_cameraservice.cameraId UTF8String], CMD_PTZ_LEFT);
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([_cameraservice.cameraId UTF8String], CMD_PTZ_LEFT_STOP);
}

- (IBAction)btn_right_onClcik:(id)sender {
    /*摄像机需在线状态*/
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([_cameraservice.cameraId UTF8String], CMD_PTZ_RIGHT);
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([_cameraservice.cameraId UTF8String], CMD_PTZ_RIGHT_STOP);
}

- (IBAction)btn_menu_onClick:(id)sender {
    [self performSegueWithIdentifier:@"cameraPlay_to_menu" sender:self];
}

- (IBAction)btn_close_onClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出摄像头" message:@"确定退出摄像头？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) // click close button
        //[self performSegueWithIdentifier:@"cameraplay_to_room" sender:self];
    {
        [self stopPlay];
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
