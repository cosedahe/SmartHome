//
//  SMRefindPwdViewController.h
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMLoginBaseViewController.h"
#import "Socket/SocketMessage.h"

@interface SMRefindPwdViewController : SMLoginBaseViewController <UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)btn_back_onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)sure:(id)sender;
@end
