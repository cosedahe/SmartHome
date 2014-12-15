//
//  SMTelevisionViewController.m
//  SmartHome
//
//  Created by He Teli on 14-12-1.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMTelevisionViewController.h"

@interface SMTelevisionViewController ()

@end

@implementation SMTelevisionViewController
@synthesize furniture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    socketmessage = [SocketMessage getInstance];
    // set boarder of view
    self.TVView.layer.masksToBounds = YES;
    self.TVView.layer.cornerRadius = 6.0;
    self.TVView.layer.borderWidth = 1.0;
    self.TVView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    // add button onclick listener
    [self initButtonList];
    
    widgetlist = [[NSMutableArray alloc] init];
    widgetdao = [[WidgetDao alloc] init];
    furnituredao = [[FurnitureDao alloc] init];
    widgetservice = [[WidgetService alloc] init];
    widgetlist = [widgetdao getListByFatherId:[furniture getId]];
    if([widgetlist count] == 0)
    {
        NSMutableArray *widgetId = [[NSMutableArray alloc] init];
        for(int i = 0; i < [buttonlist count]; i++)
        {
            [widgetId addObject:[NSNumber numberWithInt:i]];
        }
        widgetlist = [widgetservice addWidget:furniture :widgetId];
    }
}

-(void) initButtonList
{
    buttonlist = [[NSMutableArray alloc] init];
    [buttonlist addObject:self.btn_television_blank];
    [buttonlist addObject:self.btn_television_center_button];
    [buttonlist addObject:self.btn_television_down_button];
    [buttonlist addObject:self.btn_television_eight];
    [buttonlist addObject:self.btn_television_exit];
    [buttonlist addObject:self.btn_television_fen];
    [buttonlist addObject:self.btn_television_five];
    [buttonlist addObject:self.btn_television_four];
    [buttonlist addObject:self.btn_television_left_button];
    [buttonlist addObject:self.btn_television_menu];
    [buttonlist addObject:self.btn_television_mute];
    [buttonlist addObject:self.btn_television_nine];
    [buttonlist addObject:self.btn_television_off];
    [buttonlist addObject:self.btn_television_one];
    [buttonlist addObject:self.btn_television_right_button];
    [buttonlist addObject:self.btn_television_seven];
    [buttonlist addObject:self.btn_television_six];
    [buttonlist addObject:self.btn_television_three];
    [buttonlist addObject:self.btn_television_tv];
    [buttonlist addObject:self.btn_television_tv_stb];
    [buttonlist addObject:self.btn_television_two];
    [buttonlist addObject:self.btn_television_up_button];
    [buttonlist addObject:self.btn_television_zero];
    
    for(UIButton *button in buttonlist)
    {
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(IBAction)buttonClicked:(id)sender
{
    for(int i = 0; i < [buttonlist count]; i++)
    {
        // set background image
        if([self.btn_television_off isEqual:[buttonlist objectAtIndex:i]])
        {
            self.btn_television_off.imageView.image = [UIImage imageNamed:@"colse1.png"];
        }
        else if ([self.btn_television_tv_stb isEqual:[buttonlist objectAtIndex:i]])
        {
            self.btn_television_tv_stb.imageView.image = [UIImage imageNamed:@"tv_img.png"];
        }
        else if ([self.btn_television_mute isEqual:[buttonlist objectAtIndex:i]])
        {
            self.btn_television_tv_stb.imageView.image = [UIImage imageNamed:@"television_mute1"];
        }
        else
        {
            UIButton *button = [buttonlist objectAtIndex:i];
            button.imageView.image = [UIImage imageNamed:@"air_lucency1.png"];
        }
        
        if([sender isEqual:[buttonlist objectAtIndex:i]])
        {
            // send downcode
            [socketmessage sendDownCode:[[widgetlist objectAtIndex:i] getDowncode]];
            
            if([self.btn_television_off isEqual:[buttonlist objectAtIndex:i]])
            {
                self.btn_television_off.imageView.image = [UIImage imageNamed:@"colse3.png"];
            }
            else if([self.btn_television_mute isEqual:[buttonlist objectAtIndex:i]])
            {
                self.btn_television_mute.imageView.image = [UIImage imageNamed:@"television_mute2.png"];
            }
            else if([self.btn_television_tv_stb isEqual:[buttonlist objectAtIndex:i]])
            {
                self.btn_television_tv_stb.imageView.image = [UIImage imageNamed:@"tv_img1.png"];
            }
            else
            {
                UIButton *button = [buttonlist objectAtIndex:i];
                button.imageView.image = [UIImage imageNamed:@"air_lucency3.png"];
            }
        }
    }
    
    UIButton *button = (UIButton *)sender;
    [furniture setLastdo:button.titleLabel.text];
    [furnituredao updateObj:furniture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_back_onClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btn_learn_onClick:(id)sender {
    [socketmessage sendIRCode:0];
}

- (IBAction)btn_tv_mute_onClick:(id)sender {
}

- (IBAction)btn_off_onClick:(id)sender {
}
@end
