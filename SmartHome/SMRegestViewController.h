//
//  SMRegestViewController.h
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMLoginBaseViewController.h"


@interface SMRegestViewController : SMLoginBaseViewController <UIAlertViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, MBProgressHUDDelegate>
{
    int viewOffsetY;
}

- (IBAction)back:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)regest:(UIButton *)sender;
-(void)responseMsg;

@end

/*@interface myOnReceiverMessageListener :OnReceiverMessageListener
-(void)getReceiveRegestResponseMessage:(NSString *)socketconnect;
@end*/