//
//  SMCurtainViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-28.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FurnitureBean.h"
#import "FurnitureDao.h"
#import "WidgetDao.h"
#import "OnIfSucceedMessageListener.h"
#import "UDPSocketTask.h"
#import "BaseViewController.h"

@interface SMCurtainViewController : BaseViewController
{
    FurnitureDao *furnituredao;
    WidgetDao *widgetdao;
    OnIfSucceedMessageListener *onSucceedListener;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView_curtain_background;
@property FurnitureBean *furniture;

- (IBAction)btn_open_onClick:(id)sender;
- (IBAction)btn_stop_onClick:(id)sender;
- (IBAction)btn_close_onClick:(id)sender;
- (IBAction)btn_back_onClick:(id)sender;

@end
