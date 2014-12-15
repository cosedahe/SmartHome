//
//  SMDeviceGuid3ViewController.m
//  SmartHome
//
//  Created by He Teli on 14-11-17.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMDeviceGuid3ViewController.h"
#import "ChatUtils.h"
#import "UserDao.h"
#import "UserBean.h"
#import "SocketMessage.h"

@interface SMDeviceGuid3ViewController ()

@end

@implementation SMDeviceGuid3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize deviceNum;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (IBAction)btn_finish_onClick:(id)sender {
    NSString *serverid = self.deviceNum;
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    
    if([serverid isEqualToString:@""])
    {
        alertView.message = @"设备号不能为空";
        [alertView show];
    }
    else
    {
        if([ChatUtils isNumberic:serverid])
        {
            [self addDevice:[serverid longLongValue]];
        }
        else
        {
            alertView.message = @"设备号只能是数字";
            [alertView show];
        }
        
        @try
        {
            [self performSegueWithIdentifier:@"guide3_to_home" sender:self];
        }
        @catch(NSException *e)
        {
            NSLog(@"Exception:%@", e);
        }
    }
}

-(void)addDevice:(long)device_number
{
    // check if devicenumber is alerdy used
    UserDao *userdao = [[UserDao alloc] init];
    if([userdao getIdByDeviceNumber:[[SocketMessage getInstance] getName] :device_number] == 0)
    {
        UserBean *user = [[UserBean alloc] init];
        [user setDevice_number:device_number];
        [user setName:[[SocketMessage getInstance] getName]];
        [[SocketMessage getInstance] setServerid:device_number];
        
        int id = [userdao add:user];
        [user setId:id];
        // 保存userid，在情景模式中调用
        // saveUserId(id);
        // 把添加的设备号保存起来
        // messageSharedPreference.savaServerId(device_number);
    }
}

@end
