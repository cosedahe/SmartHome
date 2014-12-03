//
//  SMLoginBaseViewController.h
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "Socket/OnReceiverMessageListener.h"
#import "Socket/OnIfSucceedMessageListener.h"
#import "UDPSocketTask.h"

/* control thread running, thread will be blocked until threadRunning becoming YES*/

@interface SMLoginBaseViewController : BaseViewController
{
    MBProgressHUD *_progress;
    OnIfSucceedMessageListener *onSucceedListener;
}

@property (nonatomic ,copy) NSString*  username;
@property (nonatomic ,copy)  NSString* password;
@property (nonatomic ,copy)  NSString* email;

-(void)dismissalert:(UIAlertView*)alert;
-(BOOL)isValidateEmail:(NSString *)email;
-(BOOL)isValidateName:(NSString *)username;
-(BOOL)isValidatePwd:(NSString *)pwd;

-(void)hudWasHidden:(MBProgressHUD *)hud;
@end

@interface myOnReceiverMessageListener :OnReceiverMessageListener
-(void)getReceiveLoginResponseMessage:(NSString *)socketconnect;
-(void)getReceiveForgetPwdMessage:(NSString *)issuccessflag;
-(void)getReceiveRegestResponseMessage:(NSString *)socketconnect;
-(void)getReceiveChangePwdResponseMessage:(NSString *)socketconnect;
@end