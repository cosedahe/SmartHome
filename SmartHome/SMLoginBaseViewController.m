//
//  SMLoginBaseViewController.m
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMLoginBaseViewController.h"




/**** implementation of myOnReceiverMessageListener ****
@interface myOnReceiverMessageListener()

@end

@implementation myOnReceiverMessageListener

-(void)getReceiveLoginResponseMessage:(NSString *)socketconnect
{
    threadRunning = YES;
    result = socketconnect;
}
-(void)getReceiveRegestResponseMessage:(NSString *)socketconnect
{
    threadRunning = YES;
    result = socketconnect;
}
-(void)getReceiveForgetPwdMessage:(NSString *)socketconnect
{
    threadRunning = YES;
    result = socketconnect;
}
-(void)getReceiveChangePwdResponseMessage:(NSString *)socketconnect
{
    threadRunning = YES;
    result = socketconnect;
}
@end
*************** end implementation *******************/




@interface SMLoginBaseViewController ()

@end

@implementation SMLoginBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set listener
    onSucceedListener = [[OnIfSucceedMessageListener alloc] init];
    [[UDPSocketTask getInstance] setSucceedMessageListener:onSucceedListener];
    //[[UDPSocketTask getInstance] setReceiveMessageListerner:[[myOnReceiverMessageListener alloc] init]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 使警示框消失
-(void)dismissalert:(UIAlertView*)alert
{
    if(alert)  {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

-(BOOL)isValidateEmail:(NSString *)email
{
    //NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //NSString *emailRegex = @"^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$";
    //NSString *emailRegex = @"w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*";
    NSString *emailRegex = @"\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 账号不能少于4位
-(BOOL)isValidateName:(NSString *)username
{
    NSString *usernameRegex = @"^\\w+$";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",usernameRegex];
    return [usernameTest evaluateWithObject:username];
}

// 密码必须为6到12位的数字
-(BOOL)isValidatePwd:(NSString *)pwd
{
    NSString *pwdRegex = @"^[0-9]*$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pwdRegex];
    return [pwdTest evaluateWithObject:pwd];
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    // remove hud from screen when the hud was hidded
    [hud removeFromSuperview];
    // [hud release];
    hud = nil;
}

@end
