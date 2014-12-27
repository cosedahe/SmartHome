//
//  SMRoomViewController.m
//  SmartHome
//
//  Created by He Teli on 14-11-18.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMRoomViewController.h"
#import "CameraService.h"
#import "mytoast.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import "SocketChatUtils.h"

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
    onIfSucceedListener = [[OnIfSucceedMessageListener alloc] init];
    [[UDPSocketTask getInstance] setSucceedMessageListener:onIfSucceedListener];
    //[[UDPSocketTask getInstance] setReceiveMessageListerner:[[loginOnReceiverMessageListener alloc] init]];
    cameraservice = [CameraService getInstance];
    cameraservice.roomId = roomId;
    
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
    //gestureLongPress.minimumPressDuration = 1;
    [self.tableView addGestureRecognizer:gestureLongPress];
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
        [cell.button_turnoff setHidden:YES];
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
        [cell.button_turnoff setHidden:YES];
        [cell.button_stop setHidden:YES];
        [cell.button_turnon setHidden:YES];
    }
    else if([[bean getTag] isEqualToString:@"camera"])
    {
        cell.img_device.image = [UIImage imageNamed:@"icon_camera"];
        [cell.button_turnoff setHidden:YES];
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
#warning why service can be nil
            if([[cameraservice cameraId] isEqualToString:@""] || [[cameraservice user] isEqualToString:@""] || [[cameraservice pwd] isEqualToString:@""] || cameraservice == nil || [cameraservice isEqual:nil] || [cameraservice.cameraId isEqual:nil] || [cameraservice.user isEqual:nil] || [cameraservice.pwd isEqual:nil])
            {
                [self performSegueWithIdentifier:@"room_to_camera" sender:self];
            }
            else
            {
                [self performSegueWithIdentifier:@"room_to_cameraplay" sender:self];
            }
    }
    else if([[furniture getTag] isEqualToString:@"light"])
    {
        @try
        {
            
            [self performSegueWithIdentifier:@"room_to_light" sender:self];
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
    if(![segue.identifier isEqualToString:@"room_to_camera"] && ![segue.identifier isEqualToString:@"room_to_cameraplay"] && ![segue.identifier isEqualToString:@"room_to_home"])
    {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:furniture forKey:@"furniture"];
    }
}


- (IBAction)btn_add_onClick:(id)sender {
    
    SGMenuActionHandler handler = ^(NSInteger index)
    {
        NSLog(@"index=%ld",(long)index);
        [NSThread detachNewThreadSelector:@selector(handleAdd:) toTarget:self withObject:[NSNumber numberWithInteger:index]];
    };
    
    [SGActionView showGridMenuWithTitle:@"新设备的种类是："
                             itemTitles:@[ @"灯光", @"空调", @"报警", @"摄像头",
                                           @"窗帘", @"电视", @"插座", @"功放", @"下载" ]
                                 images:@[ [UIImage imageNamed:@"icon_light"],
                                           [UIImage imageNamed:@"icon_aircondition"],
                                           [UIImage imageNamed:@"icon_alarmbell"],
                                           [UIImage imageNamed:@"icon_camera"],
                                           [UIImage imageNamed:@"icon_curtain"],
                                           [UIImage imageNamed:@"icon_television"],
                                           [UIImage imageNamed:@"icon_outlet"],
                                           [UIImage imageNamed:@"add_room_breakgroundmusic2"],
                                           [UIImage imageNamed:@"add_room_download1"]]
                         selectedHandle:handler];
}

-(void)handleAdd:(NSNumber *)index
{
    FurnitureBean *myFurniture = [[FurnitureBean alloc] init];
    [myFurniture setRoomId:[roomId intValue]];
    
    switch([index integerValue])
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
        case 9:/*导出*/
        {
            [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:YES];
            //[self showProgress];
            
            /*download settings*/
            NSString *result = [self getUdpSocket];
            NSLog(@"导入：%@", result);
            
            /*handling message*/
            if(result != nil && ![result isEqualToString:@""])
            {
                // <tage=light,downcode=12891,12892>
                result = [result substringToIndex:([result length] - 1)];
                NSString *downcodeStr = [[result componentsSeparatedByString:@"="] objectAtIndex:2];
                NSString *tag = [[[[result componentsSeparatedByString:@"="] objectAtIndex:1] componentsSeparatedByString:@","] objectAtIndex:0];
                NSArray *downcodes = [downcodeStr componentsSeparatedByString:@","];
                NSLog(@"TAG = %@, downcode1 = %@, downcode2 = %@", tag, downcodes[0], downcodes[1]);
#warning check if it is exist
                // add to furniture
                [myFurniture setTag:@"light"];
                for(FurnitureBean *bean in furniturelist)
                {
                    if([[bean getTag] isEqualToString:@"light"])
                        newButtonNumber++;
                }
                [myFurniture setName:[[NSString alloc] initWithFormat:@"灯%d",newButtonNumber]];
                newButtonNumber = 0;
                [myFurniture setDescription:[myFurniture getTag]];
                int fId = [furnituredao add:myFurniture];
                [myFurniture setId:fId];
                [furniturelist addObject:myFurniture];
                
                // add widget
                WidgetBean *widget = [[WidgetBean alloc] init];
                WidgetDao *widgetdao = [[WidgetDao alloc] init];
                [widget setFurnitureId:[myFurniture getId]];
                [widget setTag:[myFurniture getTag]];
                
                for(int i = 0; i < [downcodes count]; i++)
                {
                    [widget setDowncode:[downcodes[i] longLongValue]];
                    [widget setWidgetid:i];
                    NSMutableArray *temp = [widgetdao getListByFatherIdAndWIdgetId:[myFurniture getId] :[widget getWidgetid]];
                    if([temp count] == 0)
                    {
                        [widgetdao add:widget];
                    }
                }
                
                [self.tableView reloadData];
            }
            [self performSelectorOnMainThread:@selector(dismisProgress) withObject:nil waitUntilDone:NO];
            //[self dismisProgress];
        }
            return;
            break;
        default:
            break;
    }
    
    [myFurniture setDescription:[myFurniture getTag]];
    int fId = [furnituredao add:myFurniture];
    [myFurniture setId:fId];
    [furniturelist addObject:myFurniture];
    
    [self.tableView reloadData];
}

-(void)showProgress
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    _progress.delegate = self;
    _progress.labelText = @"正在下载...";
    [self.view bringSubviewToFront:_progress];
    [_progress show:YES];
    
    /*_progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progress.mode = MBProgressHUDModeAnnularDeterminate;
    _progress.labelText = @"正在导入...";
    [self.view bringSubviewToFront:_progress];
    [_progress show:YES];
     */
}

-(void)dismisProgress
{
    if(_progress)
    {
        [_progress removeFromSuperview];
        _progress = nil;
    }
}

-(NSString *)getUdpSocket
{
    // consider as server
    NSString *result = [[NSString alloc] init];
    int sock;
    @try
    {
        struct sockaddr_in addr;
        addr.sin_family = AF_INET;
        addr.sin_port = htons(6666);
        addr.sin_addr.s_addr = htonl(INADDR_ANY);
        
        if ( (sock = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
        {
            perror("socket");
            exit(1);
        }
        if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0)
        {
            perror("bind");
            exit(1);
        }
        
        char buff[512];
        struct sockaddr_in clientAddr;
        int n;
        int len = sizeof(clientAddr);
        struct timeval tv_out;
        fd_set readfds;
        FD_ZERO(&readfds);
        FD_SET(sock, &readfds);
        
        tv_out.tv_sec = 30;
        tv_out.tv_usec = 0;
        int retVal = 0;
        @try
        {
            retVal = select(sock+1, &readfds, NULL, NULL, &tv_out);
            if(retVal >= 0)
            {
                if(FD_ISSET(sock, &readfds) > 0)
                {
                    n = recvfrom(sock, buff, sizeof(buff) - 1, 0, (struct sockaddr *)&clientAddr, (socklen_t *)&len);
                    
                    if (n>0)
                    {
                        buff[n] = 0;
                    }
                    else
                    {
                        perror("recv");
                    }
                }
            }
        }
        @catch(NSException *e)
        {
            NSLog(@"##SMRoomViewController## receive error:%@", e);
        }
        
        //result = [NSString stringWithCString encoding:NSUTF8StringEncoding];
        result = [NSString stringWithUTF8String:(const char *)buff];
        close(sock);
        return result;
    }
    @catch(NSException *e)
    {
        close(sock);
    }
    return nil;
}

- (IBAction)btn_back_onclick:(id)sender {
    //[self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"room_to_home" sender:self];
}

- (IBAction)btn_connect_to_host_onClick:(id)sender {
    // send downcode 0
    [NSThread detachNewThreadSelector:@selector(connecthost) toTarget:self withObject:nil];
    
}

-(void)connecthost
{
    onIfSucceedListener = [[OnIfSucceedMessageListener alloc] init];
    [[UDPSocketTask getInstance] setSucceedMessageListener:onIfSucceedListener];
    [socketmessage sendDownCode:0];
}

-(void)RecvThread:(NSNumber*)down
{
    while(!onIfSucceedListener.dataReceived)
    {
        [NSThread sleepForTimeInterval:1.0];
    }
    
    if([onIfSucceedListener.socketResult isEqualToString:@"success"])
    {
        NSLog(@"连接成功");
        [self performSelectorOnMainThread:@selector(updateLearnLabel) withObject:nil waitUntilDone:NO];
    }
    else
    {
        //socketResult = [socketResult initWithFormat:@""] ;
        NSLog(@"连接超时");
        //[self performSelectorOnMainThread:@selector(updateLearnLabel) withObject:nil waitUntilDone:NO];
    }
    onIfSucceedListener.socketResult = @"" ;
    onIfSucceedListener.dataReceived = NO;
    [NSThread exit];
}

-(void)updateLearnLabel//:(BOOL)b
{
    if (YES)
        self.btn_connect_host.titleLabel.text = @"连接成功";
    else
        self.btn_connect_host.titleLabel.text = @"连接主机";
}

NSInteger FIndexRow = -1;
-(void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.tableView];
    if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tmpPointTouch];
        if (indexPath == nil) {
            NSLog(@"not tableView");
        }else{
            FIndexRow = indexPath.row;
            UIAlertView *alertView;
            if([[[furniturelist objectAtIndex:FIndexRow] getTag] isEqualToString:@"light"])
            {
                alertView = [[UIAlertView alloc] initWithTitle:@"请选择要执行的操作:" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"编辑(暂不支持)",@"删除",@"导出", nil];
            }
            else
            {
                alertView = [[UIAlertView alloc] initWithTitle:@"请选择要执行的操作:" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"编辑(暂不支持)",@"删除", nil];
            }
            [alertView show];
        }
    }
}

BOOL isEditingFurniture = NO;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        /*编辑*/
        isEditingFurniture = YES;
        //[self performSegueWithIdentifier:@"home_to_addroom" sender:self];
    }
    else if (buttonIndex == 2)
    {
        /*删除*/
        WidgetDao *dao = [[WidgetDao alloc] init];
        FurnitureBean *bean = [furniturelist objectAtIndex:FIndexRow];
        [furniturelist removeObjectAtIndex:FIndexRow];
        [dao deleteByFatherId:[bean getId]];
        [furnituredao deleteObj:bean];
        [self.tableView reloadData];
        FIndexRow = -1;
    }
    else if (buttonIndex == 0)
    {
        /*取消*/
    }
    else if (buttonIndex == 3)
    {
        /*导出*/
        //[];
        [NSThread detachNewThreadSelector:@selector(exportWidgets) toTarget:self withObject:nil];
    }
}

-(void)exportWidgets
{
    WidgetDao *widgetdao = [[WidgetDao alloc] init];
    int myId = [[furniturelist objectAtIndex:FIndexRow] getId];
    NSMutableArray *importWidgets = [widgetdao getListByFatherId:myId];
    if([importWidgets count] != 0)
    {
        [mytoast showWithText:@"正在导出，请接收！！"];
        NSMutableString *downcode = [[NSMutableString alloc] init];
        for(int i = 0; i < [importWidgets count]; i++)
        {
            if(i == [importWidgets count] - 1)
            {
                [downcode appendFormat:@"%ld",[[importWidgets objectAtIndex:i] getDowncode]];
            }
            else
            {
                [downcode appendFormat:@"%ld",[[importWidgets objectAtIndex:i] getDowncode]];
                [downcode appendString:@","];
            }
        }
        
        NSMutableString *name = [[NSMutableString alloc] init];
        [name appendFormat:@"<tage=%@%@%@%@",[[furniturelist objectAtIndex:FIndexRow] getTag],@",downcode=",downcode,@">"];
        NSLog(@"导出:%@", name);
        
        // send export message while socket
        @try
        {
            int sockfd;
            struct sockaddr_in addr;
            int so_broadcast=1;
            
            bzero(&addr, sizeof(addr));
            addr.sin_family=AF_INET;
            addr.sin_port=htons(6666);
            addr.sin_addr.s_addr=htonl(INADDR_BROADCAST);
            bzero(&(addr.sin_zero),8);
            
            sockfd = socket(AF_INET, SOCK_DGRAM, 0); /* create a socket */
            setsockopt(sockfd,SOL_SOCKET,SO_BROADCAST,&so_broadcast,sizeof(so_broadcast));
            
            /*send message*/
            for(int j = 0; j < 4; j++)
            {
                sendto(sockfd, [name UTF8String], [name length], 0, (struct sockaddr *)&addr, sizeof(addr));
                [NSThread sleepForTimeInterval:2.0f];
            }
        }
        @catch(NSException *e)
        {
            NSLog(@"#####Exception:%@",e);
        }
    }
    else
    {
        [mytoast showWithText:@"导入失败，请先学习！！"];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] init];
    return footView;
}
@end
