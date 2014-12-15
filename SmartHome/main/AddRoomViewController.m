//
//  AddRoomViewController.m
//  SmartHome
//
//  Created by He Teli on 14-11-17.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "AddRoomViewController.h"
#import "RoomBean.h"
#import "SocketMessage.h"
#import "RoomDao.h"

static NSMutableArray *roomlist;

@interface AddRoomViewController ()

@end

@implementation AddRoomViewController

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

- (IBAction)btn_ok_onClick:(id)sender {
    BOOL isAddOrUpt = NO;
    
    NSString *roomType = [self.txt_roomType.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *roomName = [self.txt_name.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    
    if([roomType isEqualToString:@""])
    {
        alertView.message = @"房间类型不能为空";
        [alertView show];
    }
    
    if(isAddOrUpt)
    {}
    else
    {
        // 添加房间
        RoomDao *roomdao = [[RoomDao alloc] init];
        RoomBean *roombean = [[RoomBean alloc] init];
        [roombean setName:roomType];
        [roombean setUserName:[[SocketMessage getInstance] getName]];
        [roombean setDeviceNum:[[SocketMessage getInstance] getServerid]];
        [roombean setDescription:roomName];
        //[roombean setImagePath:HomeActivity.finalImagePath];
        
        int id =  [roomdao getNameById:roomType];
        if(id == 0)
        {
            id = [roomdao add:roombean];
            // HomeActivity.finalImagePath = "";
            [roombean setId:id];
            [roomlist addObject:roombean];
            // roomAdapter.notifyDataSetChanged();
            [self performSegueWithIdentifier:@"addroom_to_home" sender:self];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"警告"
                                      message:@"同名房间已经存在"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    
}

- (IBAction)btn_cancel_onClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    [self.txt_name resignFirstResponder];
    [self.txt_roomType resignFirstResponder];
}

@end
