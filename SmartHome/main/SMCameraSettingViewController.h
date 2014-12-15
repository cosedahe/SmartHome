//
//  SMCameraSettingViewController.h
//  SmartHome
//
//  Created by He Teli on 14-12-4.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "CameraService.h"

@interface SMCameraSettingViewController : BaseViewController <UserPwdProtocol>

- (IBAction)btn_back_onClick:(id)sender;
- (IBAction)btn_finish_onClick:(id)sender;
- (IBAction)btn_modifyCamPwd_onClick:(id)sender;
- (IBAction)btn_relog_onClick:(id)sender;
@property CameraService *cameraservice;
@property (weak, nonatomic) IBOutlet UILabel *label_camera1;
@property (weak, nonatomic) IBOutlet UITextField *text_newPwd;
@end
