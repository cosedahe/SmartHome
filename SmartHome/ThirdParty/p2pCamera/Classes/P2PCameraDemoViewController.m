//
//  P2PCameraDemoViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-6-13.
//
//

#import "P2PCameraDemoViewController.h"
#include "MyAudioSession.h"
#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"

#import "SearchDVS.h"

@interface P2PCameraDemoViewController ()
@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;
@property (nonatomic, retain) NSString* cameraID;
@end

@implementation P2PCameraDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _m_PPPPChannelMgt = new CPPPPChannelManagement();
    _m_PPPPChannelMgt->pCameraViewController = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    InitAudioSession();
    
}

- (void) didEnterBackground{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    [_m_PPPPChannelMgtCondition unlock];
}

- (void) willEnterForeground{
    
}

- (void)handleTimer:(NSTimer *)timer{
    [self stopSearch];
}

- (IBAction) startSearch
{
    [self stopSearch];
    
    dvs = new CSearchDVS();
    dvs->searchResultDelegate = self;
    dvs->Open();
    
    //create the start timer
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
}

- (void) stopSearch
{
    if (dvs != NULL) {
        SAFE_DELETE(dvs);
    }
}


#pragma mark -
#pragma mark SearchCameraResultProtocol

- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did{
    NSLog(@"name %@ did  %@",name, did);
}

- (IBAction)ptzController:(id)sender{
    /*摄像机需在线状态*/
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP);
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP_STOP);
}

- (IBAction)Initialize:(id)sender{
    PPPP_Initialize((char*)[@"EBGBEMBMKGJMGAJPEIGIFKEGHBMCHMJHCKBMBHGFBJNOLCOLCIEBHFOCCHKKJIKPBNMHLHCPPFMFADDFIINOIABFMH" UTF8String]);
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
}

- (IBAction)ConnectCam:(id)sender{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });

    if ([(UIButton*)sender tag] == 10) {
        //_cameraID = @"VSTC134636XDVSZ";//JPEG
        _cameraID = @"VSTC273012LSKSS";
    }else if ([(UIButton*)sender tag] == 11){
        //_cameraID = @"VSTC134636XDVSZ";//H264
        _cameraID = @"VSTC273012LSKSS";
    }
    
    [self performSelector:@selector(startPPPP:) withObject:_cameraID];
    [_m_PPPPChannelMgtCondition unlock];
}
- (IBAction)starVideo:(id)sender{
    if (_m_PPPPChannelMgt != NULL) {
        if (_m_PPPPChannelMgt->StartPPPPLivestream([_cameraID UTF8String], 10, self) == 0) {
            _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
            _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
        }
        
        _m_PPPPChannelMgt->GetCGI([_cameraID UTF8String], CGI_IEGET_CAM_PARAMS);
    }
}
- (IBAction)starAudio:(id)sender{
    _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
}
- (IBAction)stopVideo:(id)sender{
    _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
}
- (IBAction)stopAudio:(id)sender{
    _m_PPPPChannelMgt->Stop([_cameraID UTF8String]);
}

- (IBAction)startTalk:(id)sender{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StartPPPPTalk([_cameraID UTF8String]);
}

- (IBAction)stopTalk:(id)sender{
    _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
}


- (IBAction)mirrorImage:(id)sender{
    /*HORIZONTAL
     switch (flip) {
    case 0:
            flip = 2;
        break;
     
    case 1:
            flip = 3;
        break;
     
     case 2:
            flip = 0;
        break;
     
     case 3:
            flip = 1;
        break;
     
     default:
        break;
     }
     */
    
    //VERTICAL
    switch (flip) {
        case 0:
            flip = 1;
            break;
        case 1:
            flip = 0;
            break;
        case 2:
            flip = 3;
            break;
        case 3:
            flip = 2;
            break;
        default:
            break;
    }
    
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, flip);
}

- (IBAction)resolutionVideo:(id)sender{
    //HD value: 0 ~ 5 越小越高
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 16, 0);
    
    //JPEG value: 0 ~ 1 越小越高
    //_m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 0, 0);
}

- (IBAction)stopCamera:(id)sender{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    [_m_PPPPChannelMgtCondition unlock];
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });

}

- (void) startPPPP:(NSString*) camID{
#warning secrect code
    _m_PPPPChannelMgt->Start([camID UTF8String], [@"admin" UTF8String], [@"888888" UTF8String]);
}





//ImageNotifyProtocol
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did{
    [self performSelector:@selector(refreshImage:) withObject:image];
}
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{
    UIImage* image = [APICommon YUV420ToImage:yuv width:width height:height];
    [self performSelector:@selector(refreshImage:) withObject:image];
}
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
    
}
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

//refreshImage
- (void) refreshImage:(UIImage* ) image{
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(),^{
            _playView.image = image;
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ParamNotifyProtocol
- (void) ParamNotify: (int) paramType params:(void*) params{
    if (paramType == CGI_IEGET_CAM_PARAMS) {
        PSTRU_CAMERA_PARAM param = (PSTRU_CAMERA_PARAM) params;
        flip = param->flip;
    }
}

- (IBAction) PushToCamCtr:(id)sender{
    CameraControlViewController* camctr = [[CameraControlViewController alloc] init];
    camctr.m_PPPPChannelMgt = self.m_PPPPChannelMgt;
    camctr.strDID = self.cameraID;
    [self presentViewController:camctr animated:YES completion:^{
        
    }];
    [camctr release],camctr = nil;
}

@end
