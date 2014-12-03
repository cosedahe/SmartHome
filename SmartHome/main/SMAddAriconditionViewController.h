//
//  SMAddAriconditionViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-25.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FurnitureBean.h"
#import "AirService.h"
#import "AirBean.h"
#import "WidgetService.h"
#import "BaseViewController.h"

@interface SMAddAriconditionViewController : BaseViewController
{
@private NSString *name;
@private NSString *modelName;
@private NSString *windspeedName;
@private NSString *tmpName;

@private AirService *airservice;
@private long downcode;
@private WidgetService *widgetservice;
@private NSArray *modelArray;
@private NSArray *speedArray;
}

@property (weak, nonatomic) IBOutlet UILabel *label_temp;
@property (weak, nonatomic) IBOutlet UIButton *btn_model;
@property (weak, nonatomic) IBOutlet UIButton *btn_speed;
@property (weak, nonatomic) IBOutlet UISlider *slider_tmp;
@property(nonatomic,weak) FurnitureBean *furniture;
@property(nonatomic,weak) AirBean *air;

- (IBAction)btn_back_onClick:(id)sender;
- (IBAction)btn_finish_onClick:(id)sender;
- (IBAction)btn_selectType_onClick:(id)sender;
- (IBAction)btn_selectSpeed_onClick:(id)sender;
- (IBAction)slider_temp_changed:(id)sender;

@end
