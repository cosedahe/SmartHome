//
//  AirService.m
//  SmartHome
//
//  Created by Fang minghua on 14-11-25.
//  Copyright (c) 2014年 www.chongchi-tech.com. All rights reserved.
//

#import "AirService.h"

@implementation AirService

-(id)init
{
    self = [super init];
    
    if(self)
    {
        socketmessage = [SocketMessage getInstance];
        widgetdao = [[WidgetDao alloc] init];
        airdao = [[AirDao alloc] init];
        widgetdao = [[WidgetDao alloc] init];
        imiddledao = [[MiddleDao alloc] init];
    }
    
    return self;
}

-(void)deleteT:(AirBean *)bean
{
    WidgetBean *widget = [widgetdao getIdByDownCode:[bean getDowncode]];
    if(widget != nil)
    {
        [imiddledao deleteByFatherId:[widget getId]];
        [widgetdao deleteObj:widget];
    }
    [airdao deleteObj:bean];
}

-(NSMutableArray *)getChildrenById:(int)myId
{
    return [widgetdao getListByFatherId:myId];
}

-(int)addWidget:(AirBean *)bean
{
    int thisId = [airdao selectNameById:bean];
    
    if(thisId == 0)
    {
#warning why getMaxDownCode always crash
        long maxdowncode = [widgetdao getMaxDownCode];
        if(maxdowncode == 0)
        {
            maxdowncode = 5000; //getMaxDownCode
        }
        [bean setDowncode:(maxdowncode + 1)];
        return [airdao add:bean];
    }
    else
    {
        return -1;
    }
}

-(long)getMaxdowncode
{
    double UnixTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    // unsigned long long UnixTime = time(NULL);
    long maxdowncode = (unsigned long long)UnixTime % 300001;
    //if(maxdowncode >=1 && maxdowncode <=6 * 10000)
    return maxdowncode;
    //else
    //    return [self getMaxdowncode];
}

-(long)getDownCodeById:(long)downcode
{
    return [airdao getDownCodeById:downcode];
}

@end
