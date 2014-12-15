//
//  SMCameraViewController.m
//  SmartHome
//
//  Created by He Teli on 14-12-3.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMCameraViewController.h"
#include "MyAudioSession.h"
#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "SGActionView.h"

#import "SearchDVS.h"

@implementation camDevStruct

@synthesize name;
@synthesize did;

@end

@interface SMCameraViewController ()

@end

@implementation SMCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.playView setHidden:YES];
    _cameraservice = [CameraService getInstance];
    
    deviceList = [[NSMutableArray alloc] init];
    //_cameraservice.m_PPPPChannelMgt->pCameraViewController = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [_cameraservice stop];
    self.text_cameraID.text = [_cameraservice cameraId];
    self.text_user.text = [_cameraservice user];
    self.text_pwd.text = [_cameraservice pwd];
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
    id dest = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"camera_to_room"])
    {
        [dest setValue:_cameraservice.roomId forKey:@"roomId"];
    }
}

- (void)ConnectCam{
    _cameraID = self.text_cameraID.text;
    _user = self.text_user.text;
    _pwd = self.text_pwd.text;
    
    [_cameraservice setCameraId:_cameraID];
    [_cameraservice setUser:_user];
    [_cameraservice setPwd:_pwd];
    
    
    [self performSelectorOnMainThread:@selector(jump2play) withObject:nil waitUntilDone:NO];
}

- (IBAction)btn_connectCam_onClick:(id)sender {
    [self ConnectCam];
}

- (IBAction)btn_back_onClick:(id)sender {
    [self performSegueWithIdentifier:@"camera_to_room" sender:self];
}

#if 0
//PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            //[self performSelectorOnMainThread:@selector(jump) withObject:nil waitUntilDone:NO];
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    NSLog(@"PPPPStatus  %@",strPPPPStatus);
}
#endif

-(void)jump2play
{
#warning jump to play view
    [self performSegueWithIdentifier:@"camera_to_play" sender:self];

}

- (IBAction)startSearch:(id)sender
{
    [self stopSearch];
    [deviceList removeAllObjects];
    
    // show loading
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    _progress.delegate = self;
    _progress.labelText = @"正在搜索...";
    [self.view bringSubviewToFront:_progress];
    _progress.removeFromSuperViewOnHide = YES;
    [_progress show:YES];
    
    dvs = new CSearchDVS();
    dvs->searchResultDelegate = self;
    dvs->Open();
    
    //create the start timer
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
}

- (void)handleTimer:(NSTimer *)timer{
    [self stopSearch];
    if([deviceList count] == 0)
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"警告" message:@"没有找到设备!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    // show choose menu
    NSMutableArray *devName = [[NSMutableArray alloc] init];
    NSMutableArray *devDid = [[NSMutableArray alloc] init];
    for (camDevStruct *dev in deviceList)
    {
        [devName addObject:dev.name];
        [devDid addObject:dev.did];
    }
    
    [SGActionView showSheetWithTitle:@"设备搜索结果" itemTitles:devName itemSubTitles:devDid selectedIndex:0 selectedHandle:^(NSInteger index){
        _cameraID = [devDid objectAtIndex:index];
        // default user name is admin
        _user = @"admin";
        self.text_cameraID.text = _cameraID;
        self.text_user.text = _user;
    }];
}

- (void) stopSearch
{
    if(_progress)
    {
        [_progress removeFromSuperview];
        // [_progress release];
        _progress = nil;
    }
    
    if (dvs != NULL) {
        SAFE_DELETE(dvs);
    }
}


#pragma mark -
#pragma mark SearchCameraResultProtocol

- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did{
    NSLog(@"name %@ did  %@",name, did);
    for(camDevStruct *tmp in deviceList)
    {
        if([tmp.did isEqualToString:did])
        {
            return;
        }
    }
    camDevStruct *dev = [[camDevStruct alloc] init];
    [dev setName:name];
    [dev setDid:did];
    [deviceList addObject:dev];
}

#pragma mark - UITextField Delegate Method
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.login_username resignFirstResponder];
    //[self.login_password resignFirstResponder];
}

@end
