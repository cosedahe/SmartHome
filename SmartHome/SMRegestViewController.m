//
//  SMRegestViewController.m
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMRegestViewController.h"
#import "MBProgressHUD.h"
#import "SocketMessage.h"
#import "Socket/UDPSocketTask.h"

static SocketMessage *socketMessage;

static NSString *username;
static NSString *passwd;
static NSString *email;


@interface SMRegestViewController ()

@end

@implementation SMRegestViewController

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
    
    viewOffsetY = 0;
    // keyboard ntification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
    socketMessage = [SocketMessage getInstance];
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.pwdTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Method
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)back:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)regest:(UIButton *)sender {
    NSLog(@"Click Regist button");
    username = [self.usernameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    passwd = [self.pwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    email = [self.emailTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    
    if ([@"" isEqualToString:username] && [@"" isEqualToString:passwd] && [@"" isEqualToString:email]) {
        alertView.message = @"账号、密码、邮箱不能为空";
        [alertView show];
    } else if ([self isValidateEmail:email]) {
        alertView.message = @"电子邮件格式不正确，请重新输入";
        [alertView show];
    } else if (username.length < 4) {
        alertView.message = @"账号不能少于4位";
        [alertView show];
    } else if (passwd.length < 6 || passwd.length > 12) {
        alertView.message = @"密码必须为6到12位的数字";
        [alertView show];
    } else {    /*数据正确，向服务器注册账号*/
        [socketMessage sendRegestMessage:username :passwd :email];
        // [NSThread detachNewThreadSelector:responseMsg toTarget:self withObject:nil];
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.delegate = self;
        _progress.labelText = @"注册中...";
        [self.view bringSubviewToFront:_progress];
        [_progress show:YES];
        
        [NSThread detachNewThreadSelector:@selector(responseMsg) toTarget:self withObject:nil];
    }
}

-(void)responseMsg
{
    /*while(YES)
    {
        if(threadRunning)
            break;
    }*/
    
    [NSThread sleepForTimeInterval:2];
    
    if(_progress)
    {
        [_progress removeFromSuperview];
        // [_progress release];
        _progress = nil;
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

-(void)updateUI
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    
    NSLog(@"result:%@", onSucceedListener.socketResult);
    
    if([@"success" isEqualToString:onSucceedListener.socketResult])
    {
        // store name and password into file
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:username];
        [array addObject:passwd];
        [array addObject:email];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filename = [path stringByAppendingPathComponent:@"personal.plist"];
        [array writeToFile:filename atomically:YES];
        
        alertView.title = @"恭喜";
        alertView.message = @"注册成功";
        alertView.delegate = self;
        [alertView show];
        // Jump to login in alertViewCancel
    }
    else if ([@"mailExist" isEqualToString:onSucceedListener.socketResult])
    {
        alertView.message = @"邮箱已存在";
        [alertView show];
    }
    else if ([@"nameExist" isEqualToString:onSucceedListener.socketResult])
    {
        alertView.message = @"账号已存在";
        [alertView show];
    }
    else
    {
        alertView.message = @"注册失败";
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"AlertView cancel!");
    // [self performSegueWithIdentifier:@"regest_to_login" sender:self];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Responding to keyboard events

-(void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    if((self.contentView.frame.origin.y + self.contentView.frame.size.height - keyboardRect.origin.y) > 0)
    {
        [UIView animateWithDuration:animationDuration animations:^{
            //此处的viewFooter即是你的输入框View
            //20为状态栏的高度
            //self.viewFooter.frame = CGRectMake(viewFooter.frame.origin.x, keyboardRect.origin.y-20-viewFooter.frame.size.height, viewFooter.frame.size.width, viewFooter.frame.size.height);
            viewOffsetY = self.contentView.frame.origin.y + self.contentView.frame.size.height - keyboardRect.origin.y;
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, keyboardRect.origin.y - self.contentView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
            
        } completion:^(BOOL finished){
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    if(viewOffsetY > 0)
    {
        [UIView animateWithDuration:0 animations:^{
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + viewOffsetY, self.contentView.frame.size.width, self.contentView.frame.size.height);
        } completion:^(BOOL finished){
            viewOffsetY = 0;
        }];
    }
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
