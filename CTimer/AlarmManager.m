//
//  AlarmManager.m
//  CoreTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "AlarmManager.h"

@implementation AlarmManager
@synthesize arrList;

//====================================================================================================
- (id) init
{
    if(self = [super init])
    {
        arrList = [[NSMutableArray alloc] init];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if([defaults valueForKey: @"arrList"] && [[defaults valueForKey: @"arrList"] length] > 0)
        {
            NSString* strTemp = [defaults valueForKey: @"arrList"];
            NSArray* arrTempList = [strTemp componentsSeparatedByString: @"*****"];
            
            for(NSString* strItem in arrTempList)
            {
                Timer* t = [[Timer alloc] initWithData: strItem];
                [arrList addObject: t];
            }
        }
        else
        {
            
        }
    }
    return self;
}

//====================================================================================================
- (void) addTimer: (Timer*) timer
{
    [arrList addObject: timer];
}

//====================================================================================================
- (void) saveTimerList
{
    NSMutableArray* arrItems = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [arrList count]; i++)
    {
        Timer* t = [arrList objectAtIndex: i];
        NSDictionary* dicItem = [t getDictionaryForTimer];
        NSString* strItem = [self convertDictionaryToString: dicItem];
        [arrItems addObject: strItem];
    }
    
    NSString* strList = [arrItems componentsJoinedByString: @"*****"];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: strList forKey: @"arrList"];
    [defaults synchronize];
}

//====================================================================================================
- (Timer*) getCurrentTimer
{
    NSArray* arrTimers = [self workingTimers];
    if(arrTimers == nil || [arrTimers count] == 0)
    {
        return nil;
    }
    
    return [arrTimers firstObject];
}

//====================================================================================================
- (int) getOrderIndex: (Timer*) currentTimer
{
    int index = 0;
    for(Timer* t in arrList)
    {
        if([currentTimer.timer_id isEqualToString: t.timer_id])
        {
            return index + 1;
        }
        
        index ++;
    }
    
    return 0;
}

//====================================================================================================
- (Timer*) getNextTimer
{
    NSArray* arrTimers = [self workingTimers];
    if(arrTimers == nil)
    {
        return nil;
    }
    
    if([arrTimers count] >= 2)
    {
        return [arrTimers objectAtIndex: 1];
    }
    
    return nil;
}

//====================================================================================================
- (CGFloat) getPercentProgress
{
    float totalTime = 0;
    float remainingTime = 0;

    for (Timer* timer in [self workingTimers]) {
        totalTime += timer.timer;
        remainingTime += timer.remain_timer;
    }
    
    for (Timer* timer in [self finishedTimers]) {
        totalTime += timer.timer;
    }
    
    return (totalTime - remainingTime) / totalTime;
}

//====================================================================================================
- (int) getFinishedTaskCount
{
    return (int)[[self finishedTimers] count];
}

//====================================================================================================
- (int) getRemainTaskCount
{
    return (int)[arrList count] - [self getFinishedTaskCount];
}

//====================================================================================================
- (NSString*) getFinishedTaskNames
{
    NSMutableArray* arrNames = [[NSMutableArray alloc] init];
    NSArray* arrFinishedTimers = [self finishedTimers];
    for(Timer* t in arrFinishedTimers)
    {
        [arrNames addObject: t.name];
    }
    
    if([arrNames count] == 0)
    {
        return @"";
    }
    {
        return [arrNames componentsJoinedByString: @", "];
    }
}

//====================================================================================================
- (NSArray*) finishedTimers
{
    NSMutableArray* arrResult = [[NSMutableArray alloc] init];
    for(Timer* t in arrList)
    {
        if(t.status)
        {
            [arrResult addObject: t];
        }
    }
    
    return arrResult;
}

//====================================================================================================
- (NSArray*) workingTimers
{
    NSMutableArray* arrResult = [[NSMutableArray alloc] init];
    for(Timer* t in arrList)
    {
        if(!t.status)
        {
            [arrResult addObject: t];
        }
    }
    
    return arrResult;
}

//====================================================================================================
- (NSString*) convertDictionaryToString: (NSDictionary*) dicItem
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicItem
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

//====================================================================================================
- (void) resetTimerList
{
    NSArray* arrTimers = arrList;
    if(arrTimers != nil)
    {
        for(Timer* t in arrTimers)
        {
            [t resetTimer];
        }
    }
}

//====================================================================================================
@end
