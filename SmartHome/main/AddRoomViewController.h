//
//  AddRoomViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddRoomViewController : BaseViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txt_roomType;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;

- (IBAction)btn_ok_onClick:(id)sender;
- (IBAction)btn_cancel_onClick:(id)sender;
@end
