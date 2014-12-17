//
//  SMPlayViewController.m
//  SmartHome
//
//  Created by He Teli on 14-12-3.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
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
    if([[_cameraservice cameraId] isEqualToString:@""] || [[_cameraservice user] isEqualToString:@""] || [[_cameraservice pwd] isEqualToString:@""])
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
    
    /*UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:recognizer];
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cameraservice = [CameraService getInstance];
    _cameraservice.m_PPPPChannelMgt->pCameraViewController = self;
#ifndef SHOULD_STOP
    [NSThread detachNewThreadSelector:@selector(startPlay) toTarget:self withObject:nil];
#endif
    
    // Do any additional setup after loading the view.
    _alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    _playView.contentMode = UIViewContentModeScaleAspectFit;
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
    [self performSelectorOnMainThread:@selector(performTimer) withObject:nil waitUntilDone:NO];
    
    [_cameraservice Initialize];
    [self performSelector:@selector(ConnectCam) withObject:nil];
}

-(void)performTimer
{
    _processTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(handleTimeOut:) userInfo:nil repeats:NO];
}

-(void)handleTimeOut:(NSTimer *)paramTimer
{
    if(_progress)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [_progress removeFromSuperview];
        // [_progress release];
        _progress = nil;
    }
    [self stopPlay];
    
    _alertView.title = @"连接超时";
    _alertView.delegate = self;
    [_alertView show];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"cameraplay_to_room"])
    {
        id dest = [segue destinationViewController];
        [dest setValue:_cameraservice.roomId forKey:@"roomId"];
    }
}


//ImageNotifyProtocol
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did{
    if(_progress)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [_progress removeFromSuperview];
        // [_progress release];
        _progress = nil;
    }
    if(_processTimer != nil)
    {
        [_processTimer invalidate];
    }
    [self performSelector:@selector(refreshImage:) withObject:image];
}
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{
    if(_progress)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [_progress removeFromSuperview];
        // [_progress release];
        _progress = nil;
    }
    if(_processTimer != nil)
    {
        [_processTimer invalidate];
    }
    
    UIImage* image = [APICommon YUV420ToImage:yuv width:width height:height];
    [self performSelector:@selector(refreshImage:) withObject:image];
}
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
}

//refreshImage
- (void) refreshImage:(UIImage* ) image{
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(),^{
            //NSLog(@"height = %f, width = %f.", image.size.height, image.size.width);
                       _playView.image = image;
            _playView.bounds = CGRectMake(0, 0, image.size.height, image.size.width);
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
        }
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            //[self performSelectorOnMainThread:@selector(showAlertMessage:) withObject:[NSNumber numberWithInt:status]waitUntilDone:NO];
            [self stopPlay];
            [self startPlay];
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            [self performSelectorOnMainThread:@selector(showAlertMessage:) withObject:[NSNumber numberWithInt:status]waitUntilDone:NO];
            break;
        case PPPP_STATUS_UNKNOWN:
        case PPPP_STATUS_CONNECT_FAILED:
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
        case PPPP_STATUS_CONNECT_TIMEOUT:
            [self performSelectorOnMainThread:@selector(showAlertMessage:) withObject:[NSNumber numberWithInt:status]waitUntilDone:NO];
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            [self performSelectorOnMainThread:@selector(showAlertMessage:) withObject:[NSNumber numberWithInt:status]waitUntilDone:NO];
        }
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    NSLog(@"PPPPStatus  %d",status);
}

-(void)showAlertMessage:(NSNumber *)msgType
{
    if(_processTimer != nil)
    {
        [_processTimer invalidate];
    }
    if(_progress)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [_progress removeFromSuperview];
        // [_progress release];
        _progress = nil;
    }
    
    _alertView.title = @"连接失败";
    switch([msgType intValue])
    {
        case PPPP_STATUS_DISCONNECT:
            _alertView.message = @"相机已断断线";
            break;
        case PPPP_STATUS_INVALID_ID:
            _alertView.message = @"摄像头ID不正确！";
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            _alertView.message = @"连接超时！";
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            _alertView.message =  @"用户名密码不正确！";
            _cameraservice.pwd = @"";
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            _alertView.message = @"摄像机不在线";
            break;
        default:
            _alertView.message = @"未知原因";
            break;
    }

    [_alertView show];
    
#warning should return camera view
    [self stopPlay];
    //[self dismissModalViewControllerAnimated:YES];
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    // remove hud from screen when the hud was hidded
    [hud removeFromSuperview];
    // [hud release];
    hud = nil;
}

- (IBAction)btn_up_touchDown:(id)sender {
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_UP);
}

- (IBAction)btn_left_touchDown:(id)sender {
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_LEFT);
}

- (IBAction)btn_right_touchDown:(id)sender {
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_RIGHT);
}

- (IBAction)btn_down_touchDown:(id)sender {
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_DOWN);
}

- (IBAction)btn_up_upInside:(id)sender {
    /*摄像机需在线状态*/
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_UP_STOP);
}

- (IBAction)btn_down_upInside:(id)sender {
    /*摄像机需在线状态*/
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_DOWN_STOP);
}

- (IBAction)btn_left_upInside:(id)sender {
    /*摄像机需在线状态*/
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_LEFT_STOP);
}

- (IBAction)btn_right_upInside:(id)sender {
    /*摄像机需在线状态*/
    _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_RIGHT_STOP);
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
        //[self dismissModalViewControllerAnimated:YES];
        [self performSegueWithIdentifier:@"cameraplay_to_room" sender:self];
    }
}

/*-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSLog(@"gesture recognizer: %d", recognizer.direction);
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_RIGHT);
        _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_RIGHT_STOP);
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_LEFT);
        _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_LEFT_STOP);
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_UP);
        _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_UP_STOP);
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_DOWN);
        _cameraservice.m_PPPPChannelMgt->PTZ_Control([[_cameraservice cameraId] UTF8String], CMD_PTZ_DOWN_STOP);
    }
}*/

@end
