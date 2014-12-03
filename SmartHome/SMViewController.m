//
//  SMViewController.m
//  SmartHome
//
//  Created by feihui on 14-8-25.
//  Copyright (c) 2014年 feihui. All rights reserved.
//

#import "SMViewController.h"
#import "SMLoginViewController.h"
#import "SMRegestViewController.h"
@interface SMViewController ()

@end

@implementation SMViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark 跳转到登陆界面
- (IBAction)login:(UIButton *)sender {
    
    //利用storyboard来跳转到登陆界面，要在登陆界面中制定segueID“login”
   [self performSegueWithIdentifier:@"enter_to_login" sender:self];
}

#pragma mark 跳转到注册界面
- (IBAction)regest:(UIButton *)sender {

    [self performSegueWithIdentifier:@"regest" sender:self];
}
@end
