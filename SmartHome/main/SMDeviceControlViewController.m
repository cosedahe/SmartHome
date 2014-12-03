//
//  SMDeviceControlViewController.m
//  SmartHome
//
//  Created by Fang minghua on 14-12-1.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SMDeviceControlViewController.h"

@interface SMDeviceControlViewController ()

@end

@implementation SMDeviceControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // get device list
    UserDao *dao = [[UserDao alloc] init];
    socketmessage = [SocketMessage getInstance];
    userdao = [[UserDao alloc] init];
    self.devList = [dao getUsersByName:[socketmessage getName]];
    [self.tableView_deviceList setDataSource:self];
    [self.tableView_deviceList setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.devList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView_deviceList dequeueReusableCellWithIdentifier:DEVCELLIDENTIFIER];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DEVCELLIDENTIFIER];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"device_pic.png"];
    cell.textLabel.text = [[NSNumber numberWithLong:[[self.devList objectAtIndex:indexPath.row] getDevice_number]] stringValue];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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
        UserBean *bean = [self.devList objectAtIndex:indexPath.row];
        RoomDao *roomdao = [[RoomDao alloc] init];
        [roomdao deleteRoomByUserNameAndDeviceNumber:[bean getName] :[bean getDevice_number]];
#warning delete pattern dao
        // [patterndao deleteByFatherId:userid];
        
        [userdao deleteObj:bean];
        [self.devList removeObject:bean];
        [self performSelectorOnMainThread:@selector(finishReloadingData) withObject:nil waitUntilDone:NO];
    }
}

-(void)finishReloadingData
{
    [self.tableView_deviceList reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [socketmessage setServerid:[[self.devList objectAtIndex:indexPath.row] getDevice_number]];
    [self performSegueWithIdentifier:@"devmanager_to_home" sender:self];
}

- (IBAction)btn_addDevice_onClick:(id)sender {
    // jump to device guide view
    [self performSegueWithIdentifier:@"devCtl_to_addDev" sender:self];
}

- (IBAction)btn_back_onClick:(id)sender {
    // back to home page
    long dev_num = [socketmessage getServerid];
    for(UserBean *bean in self.devList)
    {
        if([bean getDevice_number] == dev_num)
        {
            [self performSegueWithIdentifier:@"devmanager_to_home" sender:self];
            return;
        }
    }

    // device has been deleted
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"警告" message:@"当前设备已删除，请重新选择设备" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertview show];
}
@end
