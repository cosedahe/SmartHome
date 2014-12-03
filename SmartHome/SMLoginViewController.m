//
//  SMLoginViewController.m
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMLoginViewController.h"
#import "SocketMessage.h"
#import "Socket/UDPSocketTask.h"
#import "UserDao.h"

static NSString *name;
static NSString *pwd;
static NSString *email;

static SocketMessage *socketMessage;



@interface SMLoginViewController ()

@end

@implementation SMLoginViewController

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
    
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"personal.plist"];
    NSMutableArray *array=[[NSMutableArray alloc] initWithContentsOfFile:filename];
    
    if(array != nil)
    {
        @try
        {
            name = [[NSString alloc] initWithString:[array objectAtIndex:0]];
            pwd = [[NSString alloc] initWithString:[array objectAtIndex:1]];
            email = [[NSString alloc] initWithString:[array objectAtIndex:2]];
        }
        @catch(NSException *e)
        {
            NSLog(@"Exception:%@", e);
        }
    
        self.login_username.text = name;
        self.login_password.text = pwd;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
    
    socketMessage = [SocketMessage getInstance];
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

- (IBAction)btn_login_onClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    
    name = self.login_username.text;
    pwd = self.login_password.text;
    
    if([name isEqualToString:@""] || [pwd isEqualToString:@""])
    {
        alertView.message = @"账号或密码不能为空";
        [alertView show];
    }
    else if (name.length < 4)
    {
        alertView.message = @"账号不能小于四位";
        [alertView show];
    }
    else if(pwd.length < 6 || pwd.length > 12)
    {
        alertView.message = @"密码是6到12位数字";
        [alertView show];
    }
    else if (![self isValidateName:name] || ![self isValidatePwd:pwd])
    {
        alertView.message = @"格式不正确，请重新输入";
        [alertView show];
    }
    else
    {
        [socketMessage sendLoginMessage:name :pwd];
        
        // process login action
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.delegate = self;
        _progress.labelText = @"登陆中...";
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
        [array addObject:name];
        [array addObject:pwd];
        if(email != nil)
            [array addObject:email];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filename = [path stringByAppendingPathComponent:@"personal.plist"];
        [array writeToFile:filename atomically:YES];
        
        UserDao *userdao = [[UserDao alloc] init];
        NSMutableArray *users = [userdao getUsersByName:[socketMessage getName]];
        
        // jump to home view
        NSLog(@"users count:%lu", (unsigned long)[users count]);
        if([users count] == 1)
        {
            [socketMessage setServerid:[[users objectAtIndex:0] getDevice_number]];
            [self performSegueWithIdentifier:@"home" sender:self];
        }
        else if([users count] < 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"登陆成功"
                                      message:@"尊敬的用户您好！\n欢迎您使用智能家居，点击进入..."
                                      delegate:self
                                      cancelButtonTitle:@"进入匹配"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            [self performSegueWithIdentifier:@"login_to_managedev" sender:self];
        }
        
        // Jump to login in alertViewCancel
    }
    else if ([@"nameError" isEqualToString:onSucceedListener.socketResult])
    {
        alertView.message = @"登陆用户名不正确";
        [alertView show];
    }
    else if ([@"passwordError" isEqualToString:onSucceedListener.socketResult])
    {
        alertView.message = @"登陆密码不正确";
        [alertView show];
    }
    else
    {
        alertView.message = @"登陆失败";
        [alertView show];
    }
}

- (IBAction)btn_back_onClick:(id)sender {
    //[self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"login_to_enter" sender:self];
}

- (IBAction)refindpwd:(UIButton *)sender {
 [self performSegueWithIdentifier:@"refindpwd" sender:self];
}

- (IBAction)modifypwd:(UIButton *)sender {
[self performSegueWithIdentifier:@"modifypwd" sender:self];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSegueWithIdentifier:@"adddevice" sender:self];
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
    [self.login_username resignFirstResponder];
    [self.login_password resignFirstResponder];
}


#pragma mark -
#pragma mark Responding to keyboard events
int viewOffsetY = 0;
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
