//
//  AppDelegate.m
//  CTimer
//
//  Created by jian on 5/2/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize alarmManager;

//Background Alarm.
@synthesize _player;
@synthesize _backupAVAudioSessionCategory;
@synthesize _bgTask;
@synthesize _timer;
@synthesize _isBackground;
@synthesize _isFirstLaunched;

static const int _wakeUpInterval = 150;
//====================================================================================================
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    alarmManager = [[AlarmManager alloc] init];
//    [self enablePushNotification];
    
    return YES;
}

//====================================================================================================
- (void) enablePushNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
//    else {
//        // Register for Push Notifications before iOS 8
//        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                         UIRemoteNotificationTypeAlert |
//                                                         UIRemoteNotificationTypeSound)];
//    }
}

//====================================================================================================
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

//====================================================================================================
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//====================================================================================================
+(AppDelegate*) getDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

//====================================================================================================
- (void)showMessage:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: text
                                                    message: nil
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

#pragma mark -
#pragma mark - Background Keepping. (When app is background mode, app will be killed after 3 mins automatically. So I have played empty sound every 3 mins to avoid kill by iOS.)

//====================================================================================================
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self getReadyToBackground];
}

//====================================================================================================
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:_bgTask];
        _bgTask = UIBackgroundTaskInvalid;
    }];
}

//====================================================================================================
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self getReadyToForeground];
}

//====================================================================================================
- (void) getReadyToForeground
{
    if (_isFirstLaunched == NO)
    {
        [self setupAVAudioSessionCategoryPlayback];
        [self playSound];
        [self restoreAVAudioSessionCategory];
        
        [self set_isFirstLaunched:YES];
    }
    else {
        
        [self restoreAVAudioSessionCategory];
        [self stopTimer];
        [self set_isBackground:NO];
    }
}

//====================================================================================================
- (void) getReadyToBackground
{
    [self setupAVAudioSessionCategoryPlayback];
    [self playSound];
    
    [self triggerTimer];
    
    [self set_isBackground:YES];
}

//====================================================================================================
- (void) restoreAVAudioSessionCategory
{
    NSError *setCategoryErr = nil;
    [[AVAudioSession sharedInstance] setCategory: _backupAVAudioSessionCategory error:&setCategoryErr];
    NSLog(@"setCategoryErr = %@", [setCategoryErr description]);
}

//====================================================================================================
- (void) setupAVAudioSessionCategoryPlayback
{
    // Back up the AVAudioSessionCategory.
    _backupAVAudioSessionCategory = [[AVAudioSession sharedInstance] category];
    
    
    // Set up the AVAudioSessionCategory to AVAudioSessionCategoryPlayback so that the sound will be able to play in Background State.
    NSError *setCategoryErr = nil;
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    
    NSLog(@"setCategoryErr = %@", [setCategoryErr description]);
}

//====================================================================================================
- (void) playSound
{
    _player = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"void" ofType:@"wav"];
    NSURL* url = [NSURL fileURLWithPath: path];
    
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.delegate = self;
    
    if (_player == nil)
        NSLog(@"%@", [error description]);
    else
        [_player play];
}

//====================================================================================================
- (void) triggerTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeUp:) userInfo:nil repeats:YES];
}

//====================================================================================================
- (void) stopTimer
{
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

//====================================================================================================
- (void) timeUp:(NSTimer *)_timer
{
    static int i = 0;
    
    i++;
    
    if (i % _wakeUpInterval== 0) {
        [self playSound];
        NSLog(@"Wake Up\n");
    }
    
    //    NSLog(@"%d\t", i);
    //    NSTimeInterval timeLeft = [UIApplication sharedApplication].backgroundTimeRemaining;
    //    NSLog(@"remaining: %f seconds (%d mins)", timeLeft, (int)(timeLeft / 60));
}

//====================================================================================================
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Disable to access multimedia.
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [alarmManager saveTimerList];
}

//====================================================================================================
@end
