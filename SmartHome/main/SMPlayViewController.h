//
//  SMPlayViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-12-3.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
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

- (IBAction)btn_up_onClick:(id)sender;
- (IBAction)btn_down_onClick:(id)sender;
- (IBAction)btn_left_onClick:(id)sender;
- (IBAction)btn_right_onClcik:(id)sender;
- (IBAction)btn_menu_onClick:(id)sender;
- (IBAction)btn_close_onClick:(id)sender;
@end
