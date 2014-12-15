//
//  SMLightTableViewCell.m
//  SmartHome
//
//  Created by He Teli on 14-11-19.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMFurnitureTableViewCell.h"
#import "OnIfSucceedMessageListener.h"
#import "UDPSocketTask.h"

#define BUTTONTURNON    0x01
#define BUTTONTURNOFF   0x02
#define BUTTONSTOP      0x03

@implementation SMFurnitureTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self.label_roomid setHidden:YES];
    //[self initDao];
    widgetservice = [[WidgetService alloc] init];
    buttonlist = [[NSMutableArray alloc] init];
    widgetid = [[NSMutableArray alloc] init];
    widgetlist = [[NSMutableArray alloc] init];
    furnituredao = [[FurnitureDao alloc] init];
    roomdao = [[RoomDao alloc] init];
    onSucceedListener = [[OnIfSucceedMessageListener alloc] init];
    [[UDPSocketTask getInstance] setSucceedMessageListener:onSucceedListener];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)button_turnon_onclick:(id)sender {
    
    // learning
    /*if([[furniture getLastdo] isEqualToString:@"无操作"])
    {
        // [[SocketMessage getInstance] sendDownCode:0];
        // 等待学习完成
    }
    else
        [widgetservice sendDowncode:[buttonlist indexOfObject:[NSNumber numberWithInt:BUTTONTURNON]] :widgetlist];
     */
    
    [self initDao:BUTTONTURNON];
    
}

- (IBAction)button_stop_onclick:(id)sender {
    [self initDao:BUTTONTURNON];
}

- (IBAction)button_turnoff_onclick:(id)sender {
    [self initDao:BUTTONTURNOFF];
}

-(void)setlists:(NSMutableArray *)newWidgetlist :(NSMutableArray *)newButtonlist
{
    buttonlist = newButtonlist;
    widgetlist = newWidgetlist;
}

static bool inited = false;
-(void)initDao:(int)buttonId
{
        NSString *type = self.label_furniture_tag.text;
        if([type isEqualToString:@"light"])
        {
            [buttonlist removeAllObjects];
            [buttonlist addObject:[NSNumber numberWithInt:BUTTONTURNON]];
            [buttonlist addObject:[NSNumber numberWithInt:BUTTONTURNOFF]];
        }
        else
        {
#warning TODO: handle other furniture type
            return;
        }
    
        furniture = [furnituredao getFurnitureByNameAndTagAndFatherId:self.label_furniture_name.text :self.label_furniture_tag.text :[self.label_roomid.text intValue]];
    if(buttonId == BUTTONTURNON)
    {
        [furniture setLastdo:@"开"];
        [furnituredao updateObj:furniture];
    }
    else if (BUTTONTURNOFF == buttonId)
    {
        [furniture setLastdo:@"关"];
        [furnituredao updateObj:furniture];
    }
    else if (buttonId == BUTTONSTOP)
    {
        [furniture setLastdo:@"停止"];
        [furnituredao updateObj:furniture];
    }
    self.label_lastdo.text = [furniture getLastdo];
    
        roombean = [roomdao getInstanceById:[self.label_roomid.text intValue]];
        /*if(widgetservice == nil)
        {
            widgetservice = [[WidgetService alloc] init];
        }
        if(widgetdao == nil)
            widgetdao = [[WidgetDao alloc] init];
        */
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
