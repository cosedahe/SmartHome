//
//  SMCameraViewController.h
//  SmartHome
//
//  Created by He Teli on 14-12-2.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "PPPP_API.h"
#import "PPPPChannelManagement.h"
#import "ImageNotifyProtocol.h"
#import "SearchCameraResultProtocol.h"
#import "SearchDVS.h"
#import "ParamNotifyProtocol.h"
#import "CameraService.h"
#import "MBProgressHUD.h"

@interface SMCameraViewController : BaseViewController <SearchCameraResultProtocol, UIGestureRecognizerDelegate, MBProgressHUDDelegate>
{
    CSearchDVS* dvs;
    /*镜像参数*/
    int flip;
    NSMutableArray *deviceList;
}
@property MBProgressHUD *progress;

@property CameraService *cameraservice;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@property (nonatomic, retain) NSTimer* searchTimer;
@property NSString *cameraID;
@property NSString *user;
@property NSString *pwd;
@property (weak, nonatomic) IBOutlet UITextField *text_cameraID;
@property (weak, nonatomic) IBOutlet UITextField *text_user;
@property (weak, nonatomic) IBOutlet UITextField *text_pwd;

- (IBAction)btn_connectCam_onClick:(id)sender;
- (IBAction)btn_back_onClick:(id)sender;
- (IBAction)startSearch:(id)sender;

@end

@interface camDevStruct : NSObject
@property NSString *name;
@property NSString *did;
@end
