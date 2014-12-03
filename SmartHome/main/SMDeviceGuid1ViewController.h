//
//  SMDeviceGuidViewController.h
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SMDeviceGuid1ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *label_welcome;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_logo;

- (IBAction)btn_next_onClick:(id)sender;
@end
