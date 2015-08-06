//
//  AlarmManager.h
//  CTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmManager : NSObject
{
    
}

@property (nonatomic, strong) NSMutableArray            *arrList;

- (void) addTimer: (Timer*) timer;
- (Timer*) getCurrentTimer;
- (int) getOrderIndex: (Timer*) currentTimer;
- (Timer*) getNextTimer;
- (NSArray*) finishedTimers;
- (NSString*) getFinishedTaskNames;
- (CGFloat) getPercentProgress;
- (int) getRemainTaskCount;
- (int) getFinishedTaskCount;

- (void) saveTimerList;
- (void) resetTimerList;
@end
