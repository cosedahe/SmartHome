//
//  SMRoomViewCell.h
//  SmartHome
//
//  Created by He Teli on 14-11-18.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRoomViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *roomImage;
@property (weak, nonatomic) IBOutlet UILabel *lab_roomName;
@property (weak, nonatomic) IBOutlet UILabel *lab_roomNickName;
@property (weak, nonatomic) IBOutlet UILabel *lab_devices;

@end
