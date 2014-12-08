//
//  SMCameraSettingViewController.m
//  SmartHome
//
//  Created by Fang minghua on 14-12-4.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SMCameraSettingViewController.h"

@interface SMCameraSettingViewController ()

@end

@implementation SMCameraSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.label_camera1 setHidden:YES];
    [self.text_newPwd setHidden:YES];
    _cameraservice = [CameraService getInstance];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_back_onClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btn_finish_onClick:(id)sender {
    // set user password delegate
    _cameraservice.m_PPPPChannelMgt->SetUserPwdParamDelegate((char *)[_cameraservice.cameraId UTF8String], self);
    if([self.text_newPwd.text isEqualToString:@""])
    {
        NSLog(@"密码为空");
        return;
    }
    _cameraservice.m_PPPPChannelMgt->SetUserPwd((char *)[_cameraservice.cameraId UTF8String], "", "", "", "", (char *)[_cameraservice.user UTF8String], (char *)[self.text_newPwd.text UTF8String]);
}

- (IBAction)btn_modifyCamPwd_onClick:(id)sender {
    [self.label_camera1 setHidden:NO];
    [self.text_newPwd setHidden:NO];
}

- (IBAction)btn_relog_onClick:(id)sender {
    [_cameraservice.m_PPPPChannelMgtCondition lock];
    if (_cameraservice.m_PPPPChannelMgt == NULL) {
        [_cameraservice.m_PPPPChannelMgtCondition unlock];
        return;
    }
    _cameraservice.m_PPPPChannelMgt->StopAll();
    [_cameraservice.m_PPPPChannelMgtCondition unlock];
    [_cameraservice setPwd:@""];
    
    [self performSegueWithIdentifier:@"camerasettings_to_camera" sender:self];
}

-(void)UserPwdResult:(NSString *)did user1:(NSString *)strUser1 pwd1:(NSString *)strPwd1 user2:(NSString *)strUser2 pwd2:(NSString *)strPwd2 user3:(NSString *)strUser3 pwd3:(NSString *)strPwd3
{
    if([strUser3 isEqualToString:_cameraservice.user] && ![strPwd3 isEqualToString:_cameraservice.pwd])
    {
        NSLog(@"修改密码成功");
        [_cameraservice setPwd:strPwd3];
    }
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
    [self.text_newPwd resignFirstResponder];
}

@end
