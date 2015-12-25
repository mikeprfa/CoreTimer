//
//  AppDelegate.h
//  CTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Google/Analytics.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow  *               window;
@property (strong, nonatomic) AlarmManager*             alarmManager;

//Background Alarm.
@property (strong, nonatomic)   AVAudioPlayer               *_player;
@property (strong, nonatomic)   NSString                    *_backupAVAudioSessionCategory;
@property (strong, nonatomic)   NSTimer                     *_timer;
@property (nonatomic)           UIBackgroundTaskIdentifier  _bgTask;
@property (nonatomic)           BOOL                        _isBackground;
@property (nonatomic)           BOOL                        _isFirstLaunched;


+ (AppDelegate*) getDelegate;
- (void) showMessage: (NSString*) strMessage;
@end

