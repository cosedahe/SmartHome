//
//  SMLightTableViewCell.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-19.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FurnitureBean.h"
#import "FurnitureDao.h"
#import "RoomBean.h"
#import "RoomDao.h"
#import "WidgetService.h"
#import "OnIfSucceedMessageListener.h"

@interface SMFurnitureTableViewCell : UITableViewCell
{
    FurnitureBean *furniture;
    FurnitureDao *furnituredao;
    RoomBean *roombean;
    RoomDao *roomdao;
    WidgetDao *widgetdao;
    WidgetService *widgetservice;
    NSMutableArray *widgetlist;
    NSMutableArray *widgetid;
    NSMutableArray *buttonlist;
    OnIfSucceedMessageListener *onSucceedListener;
}

@property (weak, nonatomic) IBOutlet UIImageView *img_device;
@property (weak, nonatomic) IBOutlet UILabel *label_furniture_name;
@property (weak, nonatomic) IBOutlet UILabel *label_furniture_tag;
@property (weak, nonatomic) IBOutlet UILabel *label_lastdo;
@property (weak, nonatomic) IBOutlet UIButton *button_turnon;
@property (weak, nonatomic) IBOutlet UIButton *button_stop;
@property (weak, nonatomic) IBOutlet UIButton *button_turnoff;
@property (weak, nonatomic) IBOutlet UILabel *label_roomid;
- (IBAction)button_turnon_onclick:(id)sender;
- (IBAction)button_stop_onclick:(id)sender;
- (IBAction)button_turnoff_onclick:(id)sender;
-(void)setlists:(NSMutableArray *)newWidgetlist :(NSMutableArray *)newButtonlist;

@end