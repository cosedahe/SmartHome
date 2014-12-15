//
//  SMCurtainViewController.m
//  SmartHome
//
//  Created by He Teli on 14-11-28.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMCurtainViewController.h"

#define WIDGETTURNON 0
#define WIDGETSTOP 1
#define WIDGETTURNOFF 2

@interface SMCurtainViewController ()

@end

@implementation SMCurtainViewController
@synthesize furniture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // load background image
    if([[furniture getLastdo] isEqualToString:@"无操作"] || [[furniture getLastdo] isEqualToString:@"开"])
    {
        self.imageView_curtain_background.image = [UIImage imageNamed:@"curtain_turnon"];
    }
    else if ([[furniture getLastdo] isEqualToString:@"关"])
    {
        self.imageView_curtain_background.image = [UIImage imageNamed:@"curtain_turnoff"];
    }
    else if([[furniture getLastdo] isEqualToString:@"停止"])
    {
        self.imageView_curtain_background.image = [UIImage imageNamed:@"curtain_stop"];
    }
    
    furnituredao = [[FurnitureDao alloc] init];
    widgetdao = [[WidgetDao alloc] init];
    onSucceedListener = [[OnIfSucceedMessageListener alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_open_onClick:(id)sender {
    self.imageView_curtain_background.image = [UIImage imageNamed:@"curtain_turnon"];
    [furniture setLastdo:@"开"];
    [furnituredao updateObj:furniture];
    
    [self performOnClick:WIDGETTURNON];
}

- (IBAction)btn_stop_onClick:(id)sender {
    self.imageView_curtain_background.image = [UIImage imageNamed:@"curtain_stop"];
    [furniture setLastdo:@"停止"];
    [furnituredao updateObj:furniture];
    
    [self performOnClick:WIDGETSTOP];
}

- (IBAction)btn_close_onClick:(id)sender {
    self.imageView_curtain_background.image = [UIImage imageNamed:@"curtain_turnoff"];
    [furniture setLastdo:@"关"];
    [furnituredao updateObj:furniture];
    
    [self performOnClick:WIDGETTURNOFF];
}

- (IBAction)btn_back_onClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)performOnClick:(int)buttonId
{
    // send control code
    long downcode = 0;
    NSMutableArray *array = [widgetdao getListByFatherIdAndWIdgetId:[furniture getId] :buttonId];
    if([array count] == 0)
    {
        WidgetBean *bean = [[WidgetBean alloc] init];
        [bean setFurnitureId:[furniture getId]];
        [bean setTag:[furniture getTag]];
        [bean setWidgetid:buttonId];
        downcode = [widgetdao getMaxDownCode] + 1;
        [bean setDowncode:downcode];
        [widgetdao add:bean];
    }
    else
    {
        downcode = [[array objectAtIndex:0] getDowncode];
    }
    
    [[UDPSocketTask getInstance] setSucceedMessageListener:onSucceedListener];
    [NSThread detachNewThreadSelector:@selector(sendAndRecvThread:) toTarget:self withObject:[NSNumber numberWithLong:downcode]];
}

-(void)sendAndRecvThread:(NSNumber*)down
{
    NSString *curtcode = [down stringValue];
    SocketMessage *mySocketMessage = [SocketMessage getInstance];
    [mySocketMessage sendCurtCode:curtcode];
    while(!onSucceedListener.dataReceived)
    {
        [NSThread sleepForTimeInterval:1.0];
    }
    
    if([onSucceedListener.socketResult isEqualToString:@"success"])
    {
        NSLog(@"连接成功");
        //[[UDPSocketTask getInstance] removeSucceedMessageListener];
    }
    else
    {
        //socketResult = [socketResult initWithFormat:@""] ;
        NSLog(@"连接超时");
    }
    onSucceedListener.socketResult = @"" ;
    onSucceedListener.dataReceived = NO;
    [NSThread exit];
}

@end
