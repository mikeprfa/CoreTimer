//
//  Timer.m
//  CoreTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "Timer.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation Timer
@synthesize name;
@synthesize color;
@synthesize timer;
@synthesize timer_music;
@synthesize timer_id;
@synthesize status;
@synthesize createdAt;
@synthesize remain_timer;

//====================================================================================================
- (id) init
{
    if(self = [super init])
    {
        timer_id = [self getTimerID];
        status = NO;
        createdAt = [NSDate date];
    }
    return self;
}

//====================================================================================================
- (NSString*) getTimerID
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyyMMddHHmmss"];
    return [formatter stringFromDate: date];
}

//====================================================================================================
- (NSString*) getRemainTime
{
    return [Timer getHourMinuteType: remain_timer];
}

//====================================================================================================
- (NSString*) getRemainSecTime
{
    return [Timer getSecType: remain_timer];
}

//====================================================================================================
- (id) initWithData: (NSString*) strItem
{
    if(self = [super init])
    {
        NSData *data = [strItem dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        timer_id = [json valueForKey: @"timer_id"];
        name = [json valueForKey: @"name"];
        color = [self convertStringToColor: [json valueForKey: @"color"]];
        timer = [[json valueForKey: @"timer"] intValue];
        if([json valueForKey: @"timer_music"] != nil && [[json valueForKey: @"timer_music"] length] > 0)
        {
            timer_music = [json valueForKey: @"timer_music"];
        }
        status = [[json valueForKey: @"status"] boolValue];
        createdAt = [self convertStringToDate: [json valueForKey: @"createdAt"]];

        // This fixes an issue where app is first started andf the timer is immediately at the "finished" position.
        remain_timer = timer;
    }
    
    return self;
}

//====================================================================================================
- (void) checkValidation
{
    if(name == nil)
    {
        name = @"";
    }
    
    if(color == nil)
    {
        color = [UIColor clearColor];
    }
    
    if(timer_music == nil)
    {
        timer_music = @"";
    }
    
    if(createdAt == nil)
    {
        createdAt = [NSDate date];
    }
}

//====================================================================================================
- (NSDictionary*) getDictionaryForTimer
{
    [self checkValidation];
    
    NSString* time_music_path = timer_music;
    if(timer_music == nil)
    {
        time_music_path = @"";
    }
    
    NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:
                               timer_id, @"timer_id",
                               name, @"name",
                               [self convertColorToString: color], @"color",
                               [NSString stringWithFormat: @"%d", timer], @"timer",
                               time_music_path, @"timer_music",
                               [NSString stringWithFormat: @"%d", status], @"status",
                               [self convertDateToString: createdAt], @"createdAt",
                               [NSString stringWithFormat: @"%d", remain_timer], @"remain_timer",
                               nil];
    return dicResult;
}

//====================================================================================================
- (NSString*) convertDateToString: (NSDate*) date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate: date];
}

//====================================================================================================
- (NSDate*) convertStringToDate: (NSString*) string
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString: string];
}

//====================================================================================================
- (NSString*) convertColorToString: (UIColor*) selectedColor
{
    int _countComponents = (int)CGColorGetNumberOfComponents(selectedColor.CGColor);
    
    if (_countComponents == 4) {
        const CGFloat *_components = CGColorGetComponents(selectedColor.CGColor);
        CGFloat red     = _components[0];
        CGFloat green = _components[1];
        CGFloat blue   = _components[2];
        CGFloat alpha = _components[3];
        
        return [NSString stringWithFormat: @"%f %f %f %f", red, green, blue, alpha];
    }
    
    return @"";
}

//====================================================================================================
- (UIColor*) convertStringToColor: (NSString*) colorString
{
    NSArray* arrColor = [colorString componentsSeparatedByString: @" "];
    if(arrColor != nil && [arrColor count] >= 4)
    {
        UIColor* returnColor = [UIColor colorWithRed: [[arrColor objectAtIndex: 0] floatValue]
                                         green: [[arrColor objectAtIndex: 1] floatValue]
                                          blue: [[arrColor objectAtIndex: 2] floatValue]
                                         alpha: [[arrColor objectAtIndex: 3] floatValue]];
        return returnColor;
    }
    
    return [UIColor clearColor];
}

//====================================================================================================
+ (NSAttributedString*) getTimerValue: (int) hour minute: (int) minute sec: (int) second
{
    NSString *strHour = @"";
    NSString *strMinute = @"";
    NSString *strSecond = @"";
    
    if(hour != 0)
    {
        strHour = [NSString stringWithFormat:@"%d %@ ", hour, ((hour == 1) ? @"hr" : @"hrs")];
    }
    
    if(minute != 0)
    {
        strMinute = [NSString stringWithFormat:@"%d %@ ", minute, ((minute == 1) ? @"min" : @"mins")];
    }

    if(second != 0)
    {
        strSecond = [NSString stringWithFormat:@"%d sec", second];
    }
    
    NSString *prefix;
    if (hour != 0 && minute != 0 && second != 0) {
        prefix = @"";
    } else {
        prefix = @"TIMER: ";
    }
    
    NSString *result = [NSString stringWithFormat:@"%@%@%@%@", prefix, strHour, strMinute, strSecond];
    NSMutableAttributedString *attrLabel;
    attrLabel = [[NSMutableAttributedString alloc]
                 initWithString:result
                 attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:15],
                              NSForegroundColorAttributeName: UIColor.whiteColor }];

    [attrLabel setAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                                NSForegroundColorAttributeName: UIColor.whiteColor  }
                       range:[result rangeOfString:prefix]];
    
    return attrLabel;
}

//====================================================================================================
+ (NSString*) getHourMinuteType: (int) value
{
    int hour = (int)(value / 3600.0f);
    int minute = (int)((value % 3600) / 60.0f);
    int sec = value % 60;
    
    NSString* result = [NSString stringWithFormat: @"%02i:%02i:%02i", hour, minute, sec];
    return result;
}

//====================================================================================================
+ (NSString*) getSecType: (int) value
{
    int sec = value % 60;
    NSString* result = [NSString stringWithFormat: @"%02i", sec];
    return result;
}

//====================================================================================================
+ (NSString*) getTimeFormat: (int) value
{
    int hour = (int)(value / 3600.0f);
    int minute = (int)((value % 3600) / 60.0f);
    int sec = (value % 60);
    
    NSString* result = @"";
    if(hour == 0)
    {
        result = [NSString stringWithFormat: @"%d:%02i", minute, sec];
    }
    else
    {
        result = [NSString stringWithFormat: @"%d:%02i:%02i", hour, minute, sec];
    }
    
    return result;
}

//====================================================================================================
- (BOOL) isEndedTimer
{
    return NO;
}

//====================================================================================================
- (void) pauseTimer
{

}

//====================================================================================================
- (void) resumeTimer
{
    
}

#pragma mark Notification.

//====================================================================================================
- (void) setupLocalNotification
{
    
}

//====================================================================================================
- (void) rescheduleLocationNotification
{
    
}

//====================================================================================================
- (void) setupNextLocalNotification: (float) total_time
{
    
}

//====================================================================================================
- (void) scheduleNotification: (NSDate*) fireDate name: (NSString*) alertBody soundURL: (NSString*) soundName timer_id: (NSString*) timerID title: (NSString*) title
{
   
}

- (void)playAtTime:(NSTimeInterval)time withDuration:(NSTimeInterval)duration {
    NSTimeInterval shortStartDelay = 0.01;
    NSTimeInterval now = player.deviceCurrentTime;
    
    [player playAtTime:now + shortStartDelay];
    soundTimer = [NSTimer scheduledTimerWithTimeInterval:shortStartDelay + duration
                                                      target:self
                                                    selector:@selector(stopPlaying:)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void)stopPlaying:(NSTimer *)theTimer {
    [player pause];
    [soundTimer invalidate];
    soundTimer = nil;
}


//====================================================================================================
- (void) playSound
{
    NSString* path = [[NSBundle mainBundle] pathForResource: timer_music ofType:@"caf"];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error: nil];
    [self playAtTime:0 withDuration:5];
}

//====================================================================================================
- (void) resetTimer
{
    remain_timer = timer;
    status = NO;
}

//====================================================================================================
@end
