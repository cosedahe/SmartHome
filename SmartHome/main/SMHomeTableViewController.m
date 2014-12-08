//
//  SMHomeTableViewController.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-17.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SMHomeTableViewController.h"
#import "addRoomAlertView.h"
#import "RoomDao.h"
#import "SocketMessage.h"

static NSString *cellIdentifier = @"RoomCell";
static NSString *roomId;

@interface SMHomeTableViewController ()

@end

@implementation SMHomeTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // self = [super initWithStyle:style];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    RoomDao *roomdao = [[RoomDao alloc] init];
    SocketMessage *socketmessage = [SocketMessage getInstance];
    self.listItems = [[NSMutableArray alloc] init];
    self.listItems = [roomdao getRoomListByUserNameAndDeviceNumber:[socketmessage getName] :[socketmessage getServerid]];
    NSLog(@"roomlist count:%d", [self.listItems count]);
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMRoomViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[SMRoomViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    RoomBean *room = [self.listItems objectAtIndex:row];
    cell.lab_roomName.text = [room getName];
    cell.lab_roomNickName.text = [room getDescription];
    FurnitureDao *furnituredao = [[FurnitureDao alloc] init];
    NSMutableArray *furnitureList = [furnituredao getListByFatherId:[room getId]];
    if([furnitureList count] != 0)
    {
        NSMutableString *devices = [[NSMutableString alloc] initWithString:@""];
        for (FurnitureBean *bean in furnitureList)
        {
            [devices appendString:[bean getName]];
            [devices appendString:@" "];
        }
        //cell.lab_devices.lineBreakMode = NSLineBreakByWordWrapping;
        //cell.lab_devices.numberOfLines = 0;
        CGSize size = CGSizeMake(320, 200);
        CGSize size01 = [devices sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize: size lineBreakMode:NSLineBreakByWordWrapping];
        [cell.lab_devices setFrame:CGRectMake(10, 50, size01.width, size01.height)];
        cell.lab_devices.text = devices;
    }
    else
    {
        cell.lab_devices.text = @"无设备";
    }
    // cell.imageView.image = [UIImage imageNamed:[room getImagePath]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    roomId = [[NSString alloc] initWithFormat:@"%d", [[self.listItems objectAtIndex:[indexPath row]] getId] ];
    [self performSegueWithIdentifier:@"home_to_room" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"home_to_room"])
    {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:roomId forKey:@"roomId"];
    }
}

- (IBAction)btn_addRomm_onClick:(id)sender {
    // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置房间" message:@“” delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    //addRoomAlertView *alertView = [[addRoomAlertView alloc]initWithTitle:@"设置房间" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];

    //[alertView show];
}

- (IBAction)btn_relog_onclick:(id)sender {
    //[self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"home_to_menu" sender:self];
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
        /*WidgetDao *dao = [[WidgetDao alloc] init];
        FurnitureBean *bean = [furniturelist objectAtIndex:[indexPath row]];
        [furniturelist removeObjectAtIndex:[indexPath row]];
        [dao deleteByFatherId:[bean getId]];
        [furnituredao deleteObj:bean];
        //[tableView reloadData];
        //[self.tableView reloadData];
         */
        RoomDao *dao = [[RoomDao alloc] init];
        RoomBean *bean = [self.listItems objectAtIndex:indexPath.row];
        FurnitureDao *furnituredao = [[FurnitureDao alloc] init];
        [furnituredao deleteByFatherId:[bean getId]];
        [dao deleteObj:bean];
        [self.listItems removeObject:bean];
        [self performSelectorOnMainThread:@selector(finishReloadingData) withObject:nil waitUntilDone:NO];
    }
}

-(void)finishReloadingData
{
    [self.tableView reloadData];
}

@end
