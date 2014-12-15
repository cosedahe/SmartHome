//
//  SMDeviceGuid2ViewController.m
//  SmartHome
//
//  Created by He Teli on 14-11-17.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMDeviceGuid2ViewController.h"
#import "UserDao.h"
#import "SocketMessage.h"

@interface SMDeviceGuid2ViewController ()

@end

@implementation SMDeviceGuid2ViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_next_pressed:(id)sender {
    deviceNum = self.txt_deviceNum.text;
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    if(![self isValidDeviceNum:deviceNum])
    {
        alertView.message = @"主机号未8位数字";
        [alertView show];
    }
    else if ([deviceNum intValue] < 10000000)
    {
        alertView.message = @"主机号不能以0开头";
        [alertView show];
    }
    else
    {
        UserDao *userdao = [[UserDao alloc] init];
        int old_id = [userdao getIdByDeviceNumber:[[SocketMessage getInstance] getName] :[deviceNum longLongValue]];
        
        if(old_id == 0)
        {
            @try
            {
                [self performSegueWithIdentifier:@"guide2_to_guide3" sender:self];
            }
            @catch(NSException *e)
            {
                NSLog(@"Exeption:%@", e);
            }
        }
        else
        {
            alertView.message = @"此设备号已经存在，请重新填写！！！";
            [alertView show];
        }
    }
}

-(BOOL)isValidDeviceNum:(NSString *)dNum
{
    NSString *deviceNumRegex = @"^\\d{8}$";
    NSPredicate *deviceNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",deviceNumRegex];
    return [deviceNumTest evaluateWithObject:dNum];
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.txt_deviceNum resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"guide2_to_guide3"])
    {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:deviceNum forKey:@"deviceNum"];
    }
}

@end
