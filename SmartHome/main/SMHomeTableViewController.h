//
//  SMHomeTableViewController.h
//  SmartHome
//
//  Created by He Teli on 14-11-17.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRoomViewCell.h"
#import "BaseViewController.h"
#import "FurnitureDao.h"

@interface SMHomeTableViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *listItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_addRomm_onClick:(id)sender;
- (IBAction)btn_relog_onclick:(id)sender;

@end
