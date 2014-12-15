//
//  AirListItemTableViewCell.m
//  SmartHome
//
//  Created by He Teli on 14-11-26.
//  Copyright (c) 2014年 无锡冲驰软件科技有限公司. All rights reserved.
//

#import "AirListItemTableViewCell.h"
#import "../pojo/AirBean.h"
#import "../dao/AirDao.h"
#import "UDPSocketTask.h"

@implementation AirListItemTableViewCell
@synthesize tmp;
@synthesize image;
@synthesize model;
@synthesize speed;
@synthesize furniture;
@synthesize label_lastdo;

- (void)awakeFromNib
{
    // Initialization code
    self.button_set.showsTouchWhenHighlighted = YES;
    // self.button_set.buttonType = UIButtonTypeRoundedRect;
    [self.button_set.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.button_set.layer setBorderWidth: 1.0];
    [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImage:(UIImage *)img
{
    if(![img isEqual:image])
    {
        image = [img copy];
        self.image_air.image = image;
        //sel.image_air.frame
    }
}

-(void)setTmp:(NSString *)t
{
    if(![t isEqualToString:tmp])
    {
        tmp = [t copy];
        self.label_tmp.text = tmp;
    }
}

-(void)setModel:(NSString *)m
{
    if(![m isEqualToString:model])
    {
        model = [m copy];
        self.label_model.text = model;
    }
}

-(void)setSpeed:(NSString *)s
{
    if(![s isEqualToString:speed])
    {
        speed = [s copy];
        self.label_speed.text = speed;
    }
}

- (IBAction)btn_onClick:(id)sender {
    // send downcode
    // 1.getdowncode
    AirDao *airdao = [[AirDao alloc] init];
    AirBean *bean = [[AirBean alloc] init];
    [bean setTmp:tmp];
    [bean setWindspeed:speed];
    [bean setModel:model];
    [bean setFurnitureid:[furniture getId]];
    
    // update lastdo
    [furniture setLastdo:tmp];
    [[[FurnitureDao alloc] init] updateObj:furniture];
    label_lastdo.text = tmp;
    
    long downcode = [airdao getDownCodeByBean:bean];
    onSucceedListener = [[OnIfSucceedMessageListener alloc] init];
    [[UDPSocketTask getInstance] setSucceedMessageListener:onSucceedListener];
    
    [NSThread detachNewThreadSelector:@selector(sendAndRecvThread:) toTarget:self withObject:[NSNumber numberWithLong:downcode]];
}

-(void)sendAndRecvThread:(NSNumber*)down
{
    int count = 0;
    long downcode = [down longValue];
    SocketMessage *mySocketMessage = [SocketMessage getInstance];
    while(!onSucceedListener.dataReceived/*[socketResult isEqualToString:@""] || socketResult == nil*/)
    {
        if(count == 3 || onSucceedListener.socketResult != nil)
        {
            //连接超时
            break;
        }
        else
        {
            count++;
            [mySocketMessage sendDownCode:downcode];
            [NSThread sleepForTimeInterval:2];
        }
    }
    onSucceedListener.dataReceived = NO;
    
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
    onSucceedListener.socketResult = nil ;
    [NSThread exit];
}
@end
