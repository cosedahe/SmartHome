//
//  SMRoomViewController.h
//  SmartHome
//
//  Created by He Teli on 14-11-18.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FurnitureDao.h"
#import "SGGridMenu.h"
#import "SMFurnitureTableViewCell.h"
#import "../Socket/UDPSocketTask.h"
#import "SocketMessage.h"
#import "../pojo/FurnitureBean.h"
#import "BaseViewController.h"
#import "CameraService.h"

#define CELL_FURNITURE @"furniturecell"

@interface SMRoomViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
@private NSMutableArray *furniturelist;
@private FurnitureDao *furnituredao;
@private SocketMessage *socketmessage;
@private FurnitureBean *furniture;  // send to child view
@private CameraService *cameraservice;
@private OnIfSucceedMessageListener *onIfSucceedListener;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)btn_add_onClick:(id)sender;
- (IBAction)btn_back_onclick:(id)sender;
- (IBAction)btn_connect_to_host_onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_connect_host;

@property(nonatomic,weak)NSString *roomId;

@end
