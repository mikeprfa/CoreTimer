//
//  Timer.h
//  ;
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Timer : NSObject
{
    AVAudioPlayer*              player;
}

@property(nonatomic, retain) NSString*          timer_id;
@property(nonatomic, retain) NSString*          name;
@property(nonatomic, retain) UIColor*           color;

@property(nonatomic, assign) int                timer;
@property(nonatomic, assign) int                remain_timer;
@property(nonatomic, retain) NSString*          timer_music;
@property(nonatomic, assign) BOOL               status;
@property(nonatomic, retain) NSDate*            createdAt;

- (id) initWithData: (NSString*) strItem;
+ (NSString*) getTimerValue: (int) hour minute: (int) minute sec: (int) sec;
+ (NSString*) getTimeFormat: (int) sec;
+ (NSString*) getHourMinuteType: (int) value;
+ (NSString*) getSecType: (int) value;
- (NSDictionary*) getDictionaryForTimer;
- (NSString*) getRemainTime;
- (NSString*) getRemainSecTime;
- (BOOL) isEndedTimer;

- (void) pauseTimer;
- (void) resumeTimer;
- (void) resetTimer;
- (void) setupLocalNotification;
- (void) rescheduleLocationNotification;
- (void) setupNextLocalNotification: (float) total_time;
- (void) playSound;
@end
