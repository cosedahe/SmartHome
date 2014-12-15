//
//  SMDeviceGuid2ViewController.h
//  SmartHome
//
//  Created by He Teli on 14-11-17.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

static NSString *deviceNum;

@interface SMDeviceGuid2ViewController : BaseViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txt_deviceNum;
- (IBAction)btn_next_pressed:(id)sender;

@end
