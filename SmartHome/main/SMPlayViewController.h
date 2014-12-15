//
//  SMPlayViewController.h
//  SmartHome
//
//  Created by He Teli on 14-12-3.
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

@interface SMPlayViewController : BaseViewController <ImageNotifyProtocol, ParamNotifyProtocol, MBProgressHUDDelegate, UIAlertViewDelegate>
{
    /*镜像参数*/
    int flip;
}
@property (weak, nonatomic) IBOutlet UIImageView *playView;
@property CameraService *cameraservice;
@property MBProgressHUD *progress;
@property NSTimer *processTimer;
@property UIAlertView *alertView;

- (IBAction)btn_up_touchDown:(id)sender;
- (IBAction)btn_left_touchDown:(id)sender;
- (IBAction)btn_right_touchDown:(id)sender;
- (IBAction)btn_down_touchDown:(id)sender;
- (IBAction)btn_up_upInside:(id)sender;
- (IBAction)btn_down_upInside:(id)sender;
- (IBAction)btn_left_upInside:(id)sender;
- (IBAction)btn_right_upInside:(id)sender;
- (IBAction)btn_menu_onClick:(id)sender;
- (IBAction)btn_close_onClick:(id)sender;
@end
