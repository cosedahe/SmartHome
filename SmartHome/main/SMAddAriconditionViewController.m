//
//  SMAddAriconditionViewController.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-25.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "SMAddAriconditionViewController.h"
#import "SGSheetMenu.h"
#import "AirBean.h"

@interface SMAddAriconditionViewController ()

@end

@implementation SMAddAriconditionViewController
@synthesize furniture;
@synthesize air;
int modelIndex = 0;
int speedIndex = 0;
int tempIndex = 16;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //modelArray = [[NSArray alloc] initWithObjects:@"制热"/*index=0*/, @"制冷", @"除湿",@"送风", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDao];
    name = @"空调温度";
#warning set initial state of type,speed and temp
    
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

- (IBAction)btn_back_onClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btn_finish_onClick:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"警告"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
    
    if([name isEqualToString:@""] || [tmpName isEqualToString:@""] || [modelName isEqualToString:@""])
    {
        alertView.message = @"请输入完整";
        [alertView show];
    }
    else
    {
        if(air == nil)
        {
            AirBean *bean = [[AirBean alloc] init];
            [bean setName:name];
            [bean setTmp:tmpName];
            [bean setWindspeed:windspeedName];
            [bean setModel:modelName];
            [bean setFurnitureid:[furniture getId]];
            int myId = [airservice addWidget:bean];
            
            WidgetBean *widget = [[WidgetBean alloc] init];
            [widget setDowncode:[bean getDowncode]];
            [widget setFurnitureId:[furniture getId]];
            [widget setTag:[furniture getTag]];
            [widget setWidgetid:myId];
            WidgetDao *dao = [[WidgetDao alloc] init];
            int widgetid = [dao add:widget];
            
            if(myId !=0 && widgetid != 0)
            {
                if(myId == -1)
                {
                    // already exist, show warning
                    alertView.message = @"已添加过此模式，不能重复添加！";
                    [alertView show];
                }
            }
        }
        else
        {
            [air setTmp:tmpName];
            [air setModel:modelName];
            [air setWindspeed:windspeedName];
            AirDao *dao = [[AirDao alloc] init];
            [dao updateObj:air];
        }
        // return to aircondition view
        [self dismissModalViewControllerAnimated:YES];
#warning return to aircondition view
    }
}


- (IBAction)btn_selectType_onClick:(id)sender {
    
    
    SGMenuActionHandler handler = ^(NSInteger index)
    {
        modelName = [modelArray objectAtIndex:index];
        self.btn_model.titleLabel.text = modelName;
        
    };
#warning set selectedIndex
    [SGActionView showSheetWithTitle:@"选择模式类型"
                          itemTitles:modelArray
                       itemSubTitles:nil
                       selectedIndex:modelIndex
                      selectedHandle:handler];
}

- (IBAction)btn_selectSpeed_onClick:(id)sender {
    SGMenuActionHandler handler = ^(NSInteger index)
    {
        windspeedName = [speedArray objectAtIndex:index];
        self.btn_speed.titleLabel.text = windspeedName;
    };
#warning set selectedIndex
    [SGActionView showSheetWithTitle:@"选择所选模式的风速"
                          itemTitles:speedArray
                       itemSubTitles:nil
                       selectedIndex:speedIndex
                      selectedHandle:handler];
}

-(void)initDao
{
    modelArray = [[NSArray alloc] initWithObjects:@"制热"/*index=0*/, @"制冷", @"除湿",@"送风", nil];
    speedArray = [[NSArray alloc] initWithObjects:@"低速"/*index=0*/, @"中速", @"高速", nil];
    
    // furniture, air
    airservice = [[AirService alloc] init];
    widgetservice = [[WidgetService alloc] init];
    if(air != nil)
    {
        modelIndex = [modelArray indexOfObject:[air getModel]];
        speedIndex = [speedArray indexOfObject:[air getWindspeed]];
        tempIndex = [[air getTemp] intValue];
    }
    
    modelName = [modelArray objectAtIndex:modelIndex];
    windspeedName = [speedArray objectAtIndex:speedIndex];
    tmpName = [NSString stringWithFormat:@"%d", tempIndex];
    
    self.label_temp.text = tmpName;
    self.slider_tmp.value = tempIndex;
    self.btn_speed.titleLabel.text = windspeedName;
    self.btn_model.titleLabel.text = modelName;
    
}

- (IBAction)slider_temp_changed:(id)sender {
    tempIndex = self.slider_tmp.value;
    tmpName = [NSString stringWithFormat:@"%d",tempIndex];
    self.label_temp.text = tmpName;
}
@end
