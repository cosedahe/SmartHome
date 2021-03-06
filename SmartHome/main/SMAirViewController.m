//
//  SMAirViewController.m
//  SmartHome
//
//  Created by He Teli on 14-11-26.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "SMAirViewController.h"
#import "UDPSocketTask.h"


@interface SMAirViewController ()

@end

@implementation SMAirViewController
@synthesize furniture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AirListItemTableViewCell *cell = [self.airlistView dequeueReusableCellWithIdentifier:AIRMODECELL];
    if(cell == nil)
    {
        // cell = [[AirListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AIRMODECELL];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AirListItemTableViewCell" owner:self options:nil] lastObject];
    }
    
    int index = [indexPath row];
    [cell setTmp:[[airmodelist objectAtIndex:index] getTemp]];
    [cell setModel:[[airmodelist objectAtIndex:index] getModel]];
    [cell setSpeed:[[airmodelist objectAtIndex:index] getWindspeed]];
    [cell setLabel_lastdo:self.label_tmp];
    UIImage *image = [UIImage imageNamed:[modelImageList objectForKey:[[airmodelist objectAtIndex:index] getModel]]];
    [cell setImage:image];
    [cell setFurniture:furniture];
    [cell.textLabel setHighlighted:NO];
    
    cell.accessoryType = UITableViewCellAccessoryNone/*UITableViewCellAccessoryDisclosureIndicator*/;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(furniture == nil)
        return 0;
    else
    {
        return [airmodelist count];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.airlistView setDelegate:self];
    [self.airlistView setDataSource:self];
    [self.airlistView setSectionIndexColor:[UIColor clearColor]];
    socketmessage = [SocketMessage getInstance];
    [self initDao];
    
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureLongPress:)];
    //gestureLongPress.minimumPressDuration = 1;
    [self.airlistView addGestureRecognizer:gestureLongPress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"air_to_add"])
    {
        id theSegue = [segue destinationViewController];
        [theSegue setValue:furniture forKey:@"furniture"];
        if(isEditingAir)
        {
            AirBean *air = [[AirBean alloc] init];
            air = [airmodelist objectAtIndex:indexAirRow];
            [theSegue setValue:air forKey:@"air"];
            indexAirRow = -1;
            isEditingAir = NO;
        }
        else
        {
            [theSegue setValue:nil forKey:@"air"];
        }
    }
}


- (IBAction)btn_learn_onClick:(id)sender {
    onSucceedListener = [[OnIfSucceedMessageListener alloc] init];
    [[UDPSocketTask getInstance] setSucceedMessageListener:onSucceedListener];
    [socketmessage sendIRCode:0];
    //[NSThread detachNewThreadSelector:@selector(sendAndRecvThread:) toTarget:self withObject:[NSNumber numberWithLong:downcode]];
}

- (IBAction)btn_off_onClick:(id)sender {
    // turn off aircondition: widgetid = 0;
    [furniture setLastdo:@"关"];
    [furnituredao updateObj:furniture];
    self.label_tmp.text = @"关";
    
    NSMutableArray *array = [widgetdao getListByFatherIdAndWIdgetId:[furniture getId] :0];
    long downcode;
    if([array count] == 0)
    {
        WidgetBean *bean = [[WidgetBean alloc] init];
        [bean setFurnitureId:[furniture getId]];
        long maxdowncode = [widgetdao getMaxDownCode];
        downcode = maxdowncode + 1;
        [bean setDowncode:downcode];
        [bean setTag:@"aircondition"];
        [bean setWidgetid:0];
        [widgetdao add:bean];
    }
    else
    {
        downcode = [[array objectAtIndex:0] getDowncode];
    }
    
    onSucceedListener = [[OnIfSucceedMessageListener alloc] init];
    [[UDPSocketTask getInstance] setSucceedMessageListener:onSucceedListener];
    
    [NSThread detachNewThreadSelector:@selector(sendAndRecvThread:) toTarget:self withObject:[NSNumber numberWithLong:downcode]];
}

-(void)sendAndRecvThread:(NSNumber*)down
{
    long downcode = [down longValue];
    SocketMessage *mySocketMessage = [SocketMessage getInstance];
    [mySocketMessage sendDownCode:downcode];
    while(!onSucceedListener.dataReceived)
    {
        [NSThread sleepForTimeInterval:1];
    }
    
    if([onSucceedListener.socketResult isEqualToString:@"success"])
    {
        NSLog(@"连接成功");
        [[UDPSocketTask getInstance] removeSucceedMessageListener];
        [self performSelectorOnMainThread:@selector(updateLearnLabel) withObject:nil waitUntilDone:NO];
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

-(void)updateLearnLabel
{
    if(YES)
        self.btn_learn.titleLabel.text = @"学习成功";
}

- (IBAction)btn_add_onClick:(id)sender {
    @try
    {
        [self performSegueWithIdentifier:@"air_to_add" sender:self];
    }@catch(NSException *e)
    {
        NSLog(@"%@",e);
    }
}

- (IBAction)btn_back_onClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)initDao
{
    socketmessage = [[SocketMessage alloc] init];
    airdao = [[AirDao alloc] init];
    airservice = [[AirService alloc] init];
    furnituredao = [[FurnitureDao alloc] init];
    widgetdao = [[WidgetDao alloc] init];
    airmodelist = [airdao getListByFatherId:[furniture getId]];
    
    modelImageList = [NSMutableDictionary dictionaryWithCapacity:4];
    [modelImageList setObject:@"model1.png" forKey:@"制热"];
    [modelImageList setObject:@"model2.png" forKey:@"制冷"];
    [modelImageList setObject:@"model3.png" forKey:@"送风"];
    [modelImageList setObject:@"model4.png" forKey:@"除湿"];
}

-(void)viewWillAppear:(BOOL)animated
{
    airmodelist = [airdao getListByFatherId:[furniture getId]];
    [self.airlistView reloadData];
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
        AirBean *bean = [airmodelist objectAtIndex:indexPath.row];
        [airdao deleteObj:bean];
        [airmodelist removeObject:bean];
        //[tableView reloadData];
        //[self.airlistView reloadData];
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
}

-(void)reloadData
{
    [self.airlistView reloadData];
}

NSInteger indexAirRow = -1;
-(void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.airlistView];
    if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.airlistView indexPathForRowAtPoint:tmpPointTouch];
        if (indexPath == nil) {
            NSLog(@"not tableView");
        }else{
            indexAirRow = indexPath.row;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择要执行的操作:" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"编辑",@"删除", nil];
            [alertView show];
        }
    }
}

BOOL isEditingAir = NO;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        /*编辑*/
        isEditingAir = YES;
        [self performSegueWithIdentifier:@"air_to_add" sender:self];
    }
    else if (buttonIndex == 2)
    {
        /*删除*/
        AirBean *bean = [airmodelist objectAtIndex:indexAirRow];
        [airdao deleteObj:bean];
        [airmodelist removeObject:bean];
        [self.airlistView reloadData];
        indexAirRow = -1;
    }
    else if (buttonIndex == 0)
    {
        /*取消*/
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] init];
    return footView;
}

@end
