//
//  SMLightViewController.h
//  SmartHome
//
//  Created by He Teli on 14-12-16.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "FurnitureBean.h"
#import "FurnitureDao.h"
#import "RoomBean.h"
#import "RoomDao.h"
#import "WidgetService.h"
#import "OnIfSucceedMessageListener.h"

@interface SMLightViewController : BaseViewController
{
    //FurnitureBean *furniture;
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

@property(nonatomic,weak) FurnitureBean *furniture;

@property (weak, nonatomic) IBOutlet UIImageView *image_light;
- (IBAction)btn_turnon_onClick:(id)sender;
- (IBAction)btn_turnoff_onClick:(id)sender;
- (IBAction)btn_back_onClick:(id)sender;

-(void)setlists:(NSMutableArray *)newWidgetlist :(NSMutableArray *)newButtonlist;
@end
