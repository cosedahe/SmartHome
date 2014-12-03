//
//  SMHomeTableViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRoomViewCell.h"
#import "BaseViewController.h"

@interface SMHomeTableViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *listItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_addRomm_onClick:(id)sender;
- (IBAction)btn_relog_onclick:(id)sender;

@end
