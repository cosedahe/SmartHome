//
//  SMDeviceControlViewController.h
//  SmartHome
//
//  Created by He Teli on 14-12-1.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDao.h"
#import "UserBean.h"
#import "SocketMessage.h"
#import "UserDao.h"
#import "BaseViewController.h"
#import "RoomDao.h"
#import "BaseViewController.h"

#define DEVCELLIDENTIFIER @"DeviceCellIdentifier"

@interface SMDeviceControlViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
@private SocketMessage *socketmessage;
@private UserDao *userdao;
}

@property NSMutableArray *devList;

- (IBAction)btn_addDevice_onClick:(id)sender;
- (IBAction)btn_back_onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView_deviceList;

@end
