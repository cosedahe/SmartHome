//
//  SMTelevisionViewController.h
//  SmartHome
//
//  Created by He Teli on 14-12-1.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BaseViewController.h"
#import "FurnitureBean.h"
#import "SocketMessage.h"
#import "WidgetService.h"
#import "FurnitureDao.h"

@interface SMTelevisionViewController : BaseViewController
{
@private SocketMessage *socketmessage;
@private NSMutableArray *buttonlist;
@private NSMutableArray *widgetlist;
@private WidgetService *widgetservice;
@private WidgetDao *widgetdao;
@private FurnitureDao *furnituredao;
}
@property(nonatomic,weak) FurnitureBean *furniture;

@property (weak, nonatomic) IBOutlet UIView *TVView;

- (IBAction)btn_back_onClick:(id)sender;
- (IBAction)btn_learn_onClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_television_off;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_tv_stb;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_one;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_two;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_three;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_four;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_five;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_six;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_seven;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_eight;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_nine;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_zero;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_fen;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_mute;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_up_button;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_center_button;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_left_button;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_down_button;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_menu;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_right_button;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_blank;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_exit;
@property (weak, nonatomic) IBOutlet UIButton *btn_television_tv;
@end
