//
//  SMRoomViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-18.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FurnitureDao.h"
#import "SGGridMenu.h"
#import "SMFurnitureTableViewCell.h"
#import "../Socket/UDPSocketTask.h"
#import "SocketMessage.h"
#import "../pojo/FurnitureBean.h"
#import "BaseViewController.h"

#define CELL_FURNITURE @"furniturecell"

@interface SMRoomViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
@private NSMutableArray *furniturelist;
@private FurnitureDao *furnituredao;
@private SocketMessage *socketmessage;
@private FurnitureBean *furniture;  // send to child view
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btn_add_onClick:(id)sender;
- (IBAction)btn_back_onclick:(id)sender;
- (IBAction)btn_connect_to_host_onClick:(id)sender;

@property(nonatomic,weak)NSString *roomId;

@end
