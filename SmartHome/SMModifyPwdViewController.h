//
//  SMModifyPwdViewController.h
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMLoginBaseViewController.h"
#import "Socket/SocketMessage.h"

@interface SMModifyPwdViewController : SMLoginBaseViewController <UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *oldpwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *newpwdTextField;
- (IBAction)modifypwd:(id)sender;
- (IBAction)btn_back_onClick:(id)sender;
@end
