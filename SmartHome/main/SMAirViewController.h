//
//  SMAirViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-26.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketMessage.h"
#import "AirListItemTableViewCell.h"
#import "AirService.h"
#import "OnIfSucceedMessageListener.h"

#define AIRMODECELL @"airmodeIndentifier"

/*
@interface myAirOnIfSucceedMessageListener : OnIfSucceedMessageListener
@property BOOL dataReceived;
@property NSString *socketResult;
@end
*/

@interface SMAirViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    SocketMessage *socketmessage;
    AirService *airservice;
    FurnitureDao *furnituredao;
    AirDao *airdao;
    WidgetDao *widgetdao;
    NSMutableArray *airmodelist;
@private NSMutableDictionary *modelImageList;
@private NSMutableArray *buttonlist;
    OnIfSucceedMessageListener *onSucceedListener;
}
@property (weak, nonatomic) IBOutlet UITableView *airlistView;
@property(nonatomic,weak) FurnitureBean *furniture;
@property (weak, nonatomic) IBOutlet UILabel *label_tmp;
@property (weak, nonatomic) IBOutlet UIButton *btn_off;

- (IBAction)btn_learn_onClick:(id)sender;
- (IBAction)btn_off_onClick:(id)sender;
- (IBAction)btn_add_onClick:(id)sender;
- (IBAction)btn_back_onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_learn;
-(void)sendAndRecvThread:(NSNumber*)down;
@end