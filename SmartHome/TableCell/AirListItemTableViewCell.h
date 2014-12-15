//
//  AirListItemTableViewCell.h
//  SmartHome
//
//  Created by He Teli on 14-11-26.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FurnitureBean.h"
#import "SMAirViewController.h"
#import "../Socket/OnIfSucceedMessageListener.h"

@interface AirListItemTableViewCell : UITableViewCell
{
    OnIfSucceedMessageListener *onSucceedListener;
}

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *model;
@property (copy, nonatomic) NSString *speed;
@property (copy, nonatomic) NSString *tmp;
@property FurnitureBean *furniture;
@property UILabel *label_lastdo;


@property (weak, nonatomic) IBOutlet UILabel *label_model;
@property (weak, nonatomic) IBOutlet UILabel *label_speed;
@property (weak, nonatomic) IBOutlet UILabel *label_tmp;
@property (weak, nonatomic) IBOutlet UIImageView *image_air;
- (IBAction)btn_onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *button_set;

@end