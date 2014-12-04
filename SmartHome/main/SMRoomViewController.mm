//
//  SMRoomViewController.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-18.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SMRoomViewController.h"

static int newButtonNumber = 0;

/**** implementation of myOnReceiverMessageListener ****/
/*@interface roomOnReceiverMessageListener()

@end

@implementation roomOnReceiverMessageListener

-(void)getReceiveLoginResponseMessage:(NSString *)socketconnect
{
    threadRunning = YES;
    result = socketconnect;
}
@end*/
/*************** end implementation *******************/

@interface SMRoomViewController ()

@end

@implementation SMRoomViewController
@synthesize roomId;

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
    // Do any additional setup after loading the view.
    furnituredao = [[FurnitureDao alloc] init];
    furniturelist = [[NSMutableArray alloc] init];
    furniturelist = [furnituredao getListByFatherId:[roomId intValue]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    socketmessage = [SocketMessage getInstance];
    // set listener
#warning set listener
    [[UDPSocketTask getInstance] setSucceedMessageListener:[[OnIfSucceedMessageListener alloc] init]];
    //[[UDPSocketTask getInstance] setReceiveMessageListerner:[[loginOnReceiverMessageListener alloc] init]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [furniturelist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    FurnitureBean *bean = [furniturelist objectAtIndex:row];
    
    SMFurnitureTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_FURNITURE];
    if(cell == nil)
    {
        //cell = [[SMFurnitureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_FURNITURE];
        
        cell = (SMFurnitureTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMFurnitureTableViewCell class]) owner:self options:nil] objectAtIndex:0];
    }
    cell.label_furniture_name.text = [bean getName];
    cell.label_furniture_tag.text = [bean getTag];
    cell.label_lastdo.text = [bean getLastdo];
    cell.label_roomid.text = roomId;
    
    if([[bean getTag] isEqualToString:@"light"]) //灯光
    {
        cell.img_device.image = [UIImage imageNamed:@"icon_light"];
        //cell.button_stop.isHidden = YES;
        [cell.button_stop setHidden:YES];
    }
    else if([[bean getTag] isEqualToString:@"aircondition"])
    {
        cell.img_device.image = [UIImage imageNamed:@"icon_aircondition"];
        [cell.button_turnoff setHidden:NO];
        [cell.button_stop setHidden:YES];
        [cell.button_turnon setHidden:YES];
    }
    else if([[bean getTag] isEqualToString:@"curtain"])
    {
        cell.img_device.image = [UIImage imageNamed:@"icon_curtain"];
        [cell.button_stop setHidden:YES/*NO*/];
        [cell.button_turnon setHidden:YES/*NO*/];
        [cell.button_turnoff setHidden:YES/*NO*/];
    }
    else if([[bean getTag] isEqualToString:@"television"])
    {
        cell.img_device.image = [UIImage imageNamed:@"icon_television"];
        //cell.button_stop.isHidden = YES;
        [cell.button_stop setHidden:YES];
        [cell.button_turnon setHidden:YES];
    }
    else if([[bean getTag] isEqualToString:@"camera"])
    {
        cell.img_device.image = [UIImage imageNamed:@"icon_camera"];
        //cell.button_stop.isHidden = YES;
        [cell.button_stop setHidden:YES];
        [cell.button_turnon setHidden:YES];
    }
    cell.accessoryType = UITableViewCellAccessoryNone/*UITableViewCellAccessoryDisclosureIndicator*/;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
#warning should be deleted?
    //[self initDao:cell];

    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete elemenet
#warning delete element
        WidgetDao *dao = [[WidgetDao alloc] init];
        FurnitureBean *bean = [furniturelist objectAtIndex:[indexPath row]];
        [furniturelist removeObjectAtIndex:[indexPath row]];
        [dao deleteByFatherId:[bean getId]];
        [furnituredao deleteObj:bean];
        //[tableView reloadData];
        //[self.tableView reloadData];
        [self performSelectorOnMainThread:@selector(finishReloadingData) withObject:nil waitUntilDone:NO];
    }
}

-(void)finishReloadingData
{
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning TODO:
    //roomId = [[NSString alloc] initWithFormat:@"%d", [[furniturelist objectAtIndex:[indexPath row]] getId] ];
    //[self performSegueWithIdentifier:@"home_to_room" sender:self];
    furniture = [furniturelist objectAtIndex:[indexPath row]];
    if([[furniture getTag] isEqualToString:@"aircondition"])
    {
        @try
        {
            [self performSegueWithIdentifier:@"room_to_air" sender:self];
        }
        @catch(NSException *e)
        {
            NSLog(@"%@",e);
        }
    }
    else if([[furniture getTag] isEqualToString:@"curtain"])
    {
        @try
        {
            
            [self performSegueWithIdentifier:@"room_to_curtain" sender:self];
        }
        @catch(NSException *e)
        {
            NSLog(@"%@",e);
        }
    }
    else if([[furniture getTag] isEqualToString:@"television"])
    {
        @try
        {
            
            [self performSegueWithIdentifier:@"room_to_television" sender:self];
        }
        @catch(NSException *e)
        {
            NSLog(@"%@",e);
        }
    }
    else if([[furniture getTag] isEqualToString:@"camera"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *cameraID = [[NSString alloc] initWithString:[defaults objectForKey:CAM_ID]];
        NSString *user = [[NSString alloc] initWithString:[defaults objectForKey:CAM_USER]];
        NSString *pwd = [[NSString alloc] initWithString:[defaults objectForKey:CAM_PWD]];
        @try
        {
            if([cameraID isEqualToString:@""] || [user isEqualToString:@""] || [pwd isEqualToString:@""])
                [self performSegueWithIdentifier:@"room_to_camera" sender:self];
            else
            {
                CameraService *service = [CameraService getInstance];
                [service setCameraId:cameraID];
                [service setUser:user];
                [service setPwd:pwd];
                [self performSegueWithIdentifier:@"room_to_cameraplay" sender:self];
            }
        }
        @catch(NSException *e)
        {
            NSLog(@"%@",e);
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if(![segue.identifier isEqualToString:@"room_to_camera"] && ![segue.identifier isEqualToString:@"room_to_cameraplay"])
    {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:furniture forKey:@"furniture"];
    }
}


- (IBAction)btn_add_onClick:(id)sender {
    SGMenuActionHandler handler = ^(NSInteger index)
    {
        NSLog(@"index=%ld",(long)index);
        
        FurnitureBean *myFurniture = [[FurnitureBean alloc] init];
        [myFurniture setRoomId:[roomId intValue]];
        
        switch(index)
        {
            case 1:
                [myFurniture setTag:@"light"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"light"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"灯%d",newButtonNumber]];
                newButtonNumber = 0;
                break;
            case 6:
                [myFurniture setTag:@"television"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"television"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"电视机%d",newButtonNumber]];
                newButtonNumber = 0;
                break;
            case 4:
                [myFurniture setTag:@"camera"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"camera"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"摄像头%d",newButtonNumber]];
                newButtonNumber = 0;
                break;
            case 2:
                [myFurniture setTag:@"aircondition"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"aircondition"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"空调%d",newButtonNumber]];
                newButtonNumber = 0;
                break;
            case 3:
                [myFurniture setTag:@"alarmbell"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"alarmbell"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"警铃%d",newButtonNumber]];
                newButtonNumber = 0;
                break;
            case 5:
                [myFurniture setTag:@"curtain"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"curtain"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"窗帘%d",newButtonNumber]];
                newButtonNumber = 0;
                break;
            case 7:
                [myFurniture setTag:@"outlet"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"outlet"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"插座%d",newButtonNumber]];
                newButtonNumber = 0;
                break;
            case 8:
                [myFurniture setTag:@"backgroundmusic"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"backgroundmusic"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"功放%d",newButtonNumber]];
                newButtonNumber = 0;
                break;
                default:
                break;
        }
        
        [myFurniture setDescription:[myFurniture getTag]];
        int fId = [furnituredao add:myFurniture];
        [myFurniture setId:fId];
        [furniturelist addObject:myFurniture];

        [self.tableView reloadData];
    };
    
    [SGActionView showGridMenuWithTitle:@"新设备的种类是："
                             itemTitles:@[ @"灯光", @"空调", @"报警", @"摄像头",
                                           @"窗帘", @"电视", @"插座", @"功放" ]
                                 images:@[ [UIImage imageNamed:@"icon_light"],
                                           [UIImage imageNamed:@"icon_aircondition"],
                                           [UIImage imageNamed:@"icon_alarmbell"],
                                           [UIImage imageNamed:@"icon_camera"],
                                           [UIImage imageNamed:@"icon_curtain"],
                                           [UIImage imageNamed:@"icon_television"],
                                           [UIImage imageNamed:@"icon_outlet"],
                                           [UIImage imageNamed:@"add_room_breakgroundmusic2"]]
                         selectedHandle:handler];
}

- (IBAction)btn_back_onclick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btn_connect_to_host_onClick:(id)sender {
    // send downcode 0
    [NSThread detachNewThreadSelector:@selector(connecthost) toTarget:self withObject:nil];
    
}

-(void)connecthost
{
    [socketmessage sendDownCode:0];
}

#define BUTTONTURNON    0x01
#define BUTTONTURNOFF   0x02
#define BUTTONSTOP      0x03
/*-(void)initDao:(SMFurnitureTableViewCell *)cell
{
    NSMutableArray *buttonlist = [[NSMutableArray alloc] init];
    NSMutableArray *widgetid = [[NSMutableArray alloc] init];
    NSMutableArray *widgetlist = [[NSMutableArray alloc] init];
    RoomBean *roombean = [[RoomBean alloc] init];
    RoomDao *roomdao = [[RoomDao alloc] init];
    FurnitureBean *furniture = [[FurnitureBean alloc] init];
    WidgetService *widgetservice;
    WidgetDao *widgetdao;
    
    furnituredao = [[FurnitureDao alloc] init];
    roomdao = [[RoomDao alloc] init];
    NSString *type = cell.label_furniture_tag.text;
    if([type isEqualToString:@"light"])
    {
        [buttonlist addObject:[NSNumber numberWithInt:BUTTONTURNON]];
        [buttonlist addObject:[NSNumber numberWithInt:BUTTONTURNOFF]];
    }
    else
    {
#warning TODO: handle other furniture type
        return;
    }
    
    furniture = [furnituredao getFurnitureByNameAndTagAndFatherId:cell.label_furniture_name.text :cell.label_furniture_tag.text :[cell.label_roomid.text intValue]];
    
    roombean = [roomdao getInstanceById:[cell.label_roomid.text intValue]];
    if(widgetservice == nil)
    {
        widgetservice = [[WidgetService alloc] init];
    }
    if(widgetdao == nil)
        widgetdao = [[WidgetDao alloc] init];
    
    widgetlist = [widgetdao getListByFatherId:[furniture getId]];
    if([widgetlist count] == 0)
    {
        for(int i = 0; i < [buttonlist count]; i++)
        {
            [widgetid addObject:[[NSNumber alloc] initWithInt:i]];
        }
        widgetlist = [widgetservice addWidget:furniture :widgetid];
    }
    
    [cell setlists:widgetlist :buttonlist];

}*/

@end
