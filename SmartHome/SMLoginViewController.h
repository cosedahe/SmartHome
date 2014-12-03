//
//  SMLoginViewController.h
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMLoginBaseViewController.h"
@interface SMLoginViewController : SMLoginBaseViewController <UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *login_username;
@property (weak, nonatomic) IBOutlet UITextField *login_password;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)btn_login_onClick:(id)sender;
- (IBAction)btn_back_onClick:(id)sender;

- (IBAction)refindpwd:(UIButton *)sender;

- (IBAction)modifypwd:(UIButton *)sender;

@end

/*@interface loginOnReceiverMessageListener :OnReceiverMessageListener
-(void)getReceiveLoginResponseMessage:(NSString *)socketconnect;
@end*/