//
//  SMModifyPwdViewController.m
//  SmartHome
//
//  Created by feihui on 14-9-18.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMModifyPwdViewController.h"

@interface SMModifyPwdViewController ()

@end

@implementation SMModifyPwdViewController

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
    // Do any additional setup after loading the view.
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.usernameTextField resignFirstResponder];
    [self.oldpwdTextField resignFirstResponder];
    [self.newpwdTextField resignFirstResponder];
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

- (IBAction)modifypwd:(id)sender {
    NSString *name = self.usernameTextField.text;
    NSString *oldpwd = self.oldpwdTextField.text;
    NSString *newpwd = self.newpwdTextField.text;
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    
    if([name isEqualToString:@""] || [oldpwd isEqualToString:@""] || [newpwd isEqualToString:@""])
    {
        alertView.message = @"账户、密码不能为空！";
        [alertView show];
    }
    else if (![self isValidateName:name] || ![self isValidatePwd:oldpwd] || ![self isValidatePwd:newpwd])
    {
        alertView.message = @"格式不正确，请重新输入！";
        [alertView show];
    }
    else if (newpwd.length < 6)
    {
        alertView.message = @"新密码不能小于六位！";
    }
    else
    {
        [[SocketMessage getInstance] sendChangePwdMessage:name :oldpwd :newpwd];
        
#warning save name and newpwd
        
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.delegate = self;
        _progress.labelText = @"正在修改...";
        [self.view bringSubviewToFront:_progress];
        [_progress show:YES];
        
        [NSThread detachNewThreadSelector:@selector(responseMsg) toTarget:self withObject:nil];
    }
}

- (IBAction)btn_back_onClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)responseMsg
{
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
        alertView.title = @"成功";
        alertView.message = @"修改密码成功";
        alertView.delegate = self;
        [alertView show];
        // Jump to login in alertViewCancel
    }
    else if ([@"fail" isEqualToString:onSucceedListener.socketResult])
    {
        alertView.message = @"修改密码失败";
        [alertView show];
    }
    else if ([@"nameError" isEqualToString:onSucceedListener.socketResult])
    {
        alertView.message = @"用户名不正确";
        [alertView show];
    }
    else if([@"passwordError" isEqualToString:onSucceedListener.socketResult])
    {
        alertView.message = @"密码不正确";
        [alertView show];
    }
    else
    {
        alertView.message = @"连接超时";
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"AlertView cancel!");
    [self dismissModalViewControllerAnimated:YES];
}
@end
