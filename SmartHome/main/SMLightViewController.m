//
//  SMLightViewController.m
//  SmartHome
//
//  Created by He Teli on 14-12-16.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMLightViewController.h"
#import "UDPSocketTask.h"

#define BUTTONTURNON    0x01
#define BUTTONTURNOFF   0x02

@interface SMLightViewController ()

@end

@implementation SMLightViewController
@synthesize furniture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    widgetservice = [[WidgetService alloc] init];
    buttonlist = [[NSMutableArray alloc] init];
    widgetid = [[NSMutableArray alloc] init];
    widgetlist = [[NSMutableArray alloc] init];
    furnituredao = [[FurnitureDao alloc] init];
    roomdao = [[RoomDao alloc] init];
    onSucceedListener = [[OnIfSucceedMessageListener alloc] init];
    [[UDPSocketTask getInstance] setSucceedMessageListener:onSucceedListener];

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

- (IBAction)btn_turnon_onClick:(id)sender {
    [self initDao:BUTTONTURNON];
}

- (IBAction)btn_turnoff_onClick:(id)sender {
    [self initDao:BUTTONTURNOFF];
}

- (IBAction)btn_back_onClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


-(void)setlists:(NSMutableArray *)newWidgetlist :(NSMutableArray *)newButtonlist
{
    buttonlist = newButtonlist;
    widgetlist = newWidgetlist;
}

static bool inited = false;
-(void)initDao:(int)buttonId
{
    [buttonlist removeAllObjects];
    [buttonlist addObject:[NSNumber numberWithInt:BUTTONTURNON]];
    [buttonlist addObject:[NSNumber numberWithInt:BUTTONTURNOFF]];
    
    if(buttonId == BUTTONTURNON)
    {
        [furniture setLastdo:@"开"];
        [furnituredao updateObj:furniture];
        self.image_light.image = [UIImage imageNamed:@"light_background.png"];
    }
    else if (BUTTONTURNOFF == buttonId)
    {
        self.image_light.image = [UIImage imageNamed:@"light_background_turnoff.png"];
        [furniture setLastdo:@"关"];
        [furnituredao updateObj:furniture];
    }

    [widgetlist removeAllObjects];
    widgetlist = [widgetdao getListByFatherIdAndWIdgetId:[furniture getId] :[buttonlist indexOfObject:[NSNumber numberWithInt:buttonId]]];
    
    
    btnId = buttonId;
    [NSThread detachNewThreadSelector:@selector(responseLearningMsg2) toTarget:self withObject:nil];
}

static int btnId = -1;

-(void)responseLearningMsg2
{
    if(btnId == -1)
        return;
    // learning
    [widgetid removeAllObjects];
    [widgetid addObject:[[NSNumber alloc] initWithInt:[buttonlist indexOfObject:[NSNumber numberWithInt:btnId]]]];
    [widgetlist removeAllObjects];
    widgetlist = [widgetservice addWidget:furniture :widgetid];
    
    [widgetservice sendDowncode:[buttonlist indexOfObject:[NSNumber numberWithInt:btnId]] :widgetlist];
    
    while(!onSucceedListener.dataReceived)
    {
        [NSThread sleepForTimeInterval:0.5];
    }
    
    if([onSucceedListener.socketResult isEqualToString:@"success"])
    {
        NSLog(@"连接成功");
        [[UDPSocketTask getInstance] removeSucceedMessageListener];
    }
    else
    {
        //socketResult = [socketResult initWithFormat:@""] ;
        NSLog(@"连接超时");
    }
    onSucceedListener.dataReceived = NO;
    onSucceedListener.socketResult = @"";
    [NSThread exit];
}

@end
