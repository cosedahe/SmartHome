//
//  WidgetService.m
//  SmartHome
//
//  Created by heteli on 14-11-19.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "WidgetService.h"
#import <time.h>

static const int STUDYCODEINT = 0x01;
static const int CURTCODEINT = 0x02;
static const int DOWNCODEINT = 0x03;

@implementation WidgetService

-(id)init
{
    self = [super init];
    
    if(self)
    {
        socketmessage = [SocketMessage getInstance];
        widgetdao = [[WidgetDao alloc] init];
    }
    
    return self;
}

-(void)sendDowncode:(int)index :(NSMutableArray *)widgetlist
{
    for(WidgetBean *bean in widgetlist)
    {
        if(index == [bean getWidgetid])
        {
            [socketmessage sendDownCode:[bean getDowncode]];
        }
    }
}

-(NSMutableArray *)addWidget:(FurnitureBean *)furniture :(NSMutableArray *)buttonlist
{
    NSMutableArray *widgetlist= [[NSMutableArray alloc] init];
    long maxdowncode = [widgetdao getMaxDownCode];
    // there is no downcode in database if it is first loaded
    if(maxdowncode == 0)
    {
#warning TODO: modify maxdowncode
        maxdowncode = 4000;
        /*maxdowncode = [self getMaxdowncode];
        while(maxdowncode < 1 || maxdowncode > 6*10000)
            maxdowncode = [self getMaxdowncode];
         */
    }
    
    for(int i = 0; i < [buttonlist count]; i++)
    {
        WidgetBean *widget = [[WidgetBean alloc] init];
        [widget setDowncode:(maxdowncode + i + 1)];
        [widget setFurnitureId:[furniture getId]];
        [widget setTag:[furniture getTag]];
        [widget setWidgetid:[[buttonlist objectAtIndex:i] intValue]];
        NSMutableArray *temp = [widgetdao getListByFatherIdAndWIdgetId:[furniture getId] :[widget getWidgetid]];
        if([temp count] == 0)
        {
            int id = [widgetdao add:widget];
            [widget setId:id];
            [widgetlist addObject:widget];
        }
        else
        {
            [widgetlist addObject:[temp objectAtIndex:0]];
        }
    }
    
    return widgetlist;
}

-(long)getMaxdowncode
{
    
    long maxdowncode = [widgetdao getMaxDownCode];
    // there is no downcode in database if it is first loaded
    if(maxdowncode == 0)
    {
#warning TODO: modify maxdowncode
        maxdowncode = 4000;
    }

    return maxdowncode;
    /*
    double UnixTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    // unsigned long long UnixTime = time(NULL);
    long maxdowncode = (unsigned long long)UnixTime % 300001;
    //if(maxdowncode >=1 && maxdowncode <=6 * 10000)
        return maxdowncode;
    //else
    //    return [self getMaxdowncode];
     */
}

@end
