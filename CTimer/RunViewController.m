//
//  RunViewController.m
//  CoreTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "RunViewController.h"
#import "CircleProgressBar.h"
#import "KKProgressTimer.h"
#import "XMCircleTypeView.h"

@interface RunViewController () <KKProgressTimerDelegate>
{
    NSTimer        *mainCheckTimer;
    Timer          *currentTimer;
    NSMutableArray *progressBars;
    BOOL           shouldAddProgressBar;
    CircleProgressBar *mainProgressOriginal;
    
    BOOL           bPaused;
}

@property (weak, nonatomic) IBOutlet CircleProgressBar      *mainProgress;
@property (weak, nonatomic) IBOutlet UIButton               *btnSkip;
@property (weak, nonatomic) IBOutlet UIView                 *viewFinishedTask;
@property (weak, nonatomic) IBOutlet UILabel                *lblFisinhed;
@property (weak, nonatomic) IBOutlet KKProgressTimer        *progressFinished;
@property (weak, nonatomic) IBOutlet UIView                 *viewCurrentTask;
@property (weak, nonatomic) IBOutlet UILabel                *lblCurrentTaskNumber;
@property (weak, nonatomic) IBOutlet UILabel                *lblCurrentTaskName;
@property (weak, nonatomic) IBOutlet UIView                 *viewNextTask;
@property (weak, nonatomic) IBOutlet UILabel                *lblNextTaskNumber;
@property (weak, nonatomic) IBOutlet UILabel                *lblNextTaskName;
@property (weak, nonatomic) IBOutlet XMCircleTypeView       *circleFinishedStatus;
@property (weak, nonatomic) IBOutlet XMCircleTypeView       *circleAHeadStatus;
@property (weak, nonatomic) IBOutlet XMCircleTypeView       *circleTimerStatus;
@property (weak, nonatomic) IBOutlet UILabel                *lblTimeCount;
@property (weak, nonatomic) IBOutlet UILabel                *lblSecondCount;
@property (weak, nonatomic) IBOutlet UIButton               *btnPlay;
@property (weak, nonatomic) IBOutlet UIView                 *viewStatus;

@end

@implementation RunViewController
@synthesize mainProgress;
@synthesize btnSkip;
@synthesize progressFinished;
@synthesize lblFisinhed;

@synthesize viewCurrentTask;
@synthesize lblCurrentTaskName;
@synthesize lblCurrentTaskNumber;

@synthesize viewNextTask;
@synthesize lblNextTaskName;
@synthesize lblNextTaskNumber;
@synthesize circleFinishedStatus;
@synthesize circleAHeadStatus;
@synthesize circleTimerStatus;

@synthesize viewStatus;
@synthesize lblTimeCount;
@synthesize btnPlay;
@synthesize lblSecondCount;

//====================================================================================================
- (void) setup
{
    [super setup];
    
    bPaused = NO;
    
    // Turn off sleep only while timers are running. Turn back on when
    // user ends timers or timers finish.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    //Init UI.
    btnSkip.layer.masksToBounds = YES;
    btnSkip.layer.cornerRadius = btnSkip.frame.size.height / 2.0f;
    
    progressFinished.progressBackgroundColor = COLOR_SEPARATOR;
    progressFinished.progressColor = COLOR_DISABLE_TEXT_COLOR;
    progressFinished.circleBackgroundColor = COLOR_SEPARATOR;
    progressFinished.delegate = self;
    
    mainProgress.hintHidden = YES;
    [mainProgress setStartAngle: -90.0];
    
    circleFinishedStatus.textAlignment = NSTextAlignmentLeft;;
    circleFinishedStatus.verticalTextAlignment = XMCircleTypeVerticalAlignOutside;
    circleFinishedStatus.baseAngle = -90.0 * M_PI / 180;
    circleFinishedStatus.textAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size:12], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    circleAHeadStatus.textAlignment = NSTextAlignmentLeft;;
    circleAHeadStatus.verticalTextAlignment = XMCircleTypeVerticalAlignOutside;
    circleAHeadStatus.baseAngle = -90.0 * M_PI / 180;
    circleAHeadStatus.textAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size:12], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    circleTimerStatus.textAlignment = NSTextAlignmentLeft;;
    circleTimerStatus.verticalTextAlignment = XMCircleTypeVerticalAlignOutside;
    circleTimerStatus.baseAngle = (-90.0 + 2.0f)* M_PI  / 180;
    circleTimerStatus.textAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size:12], NSForegroundColorAttributeName: [UIColor blackColor]};
    circleTimerStatus.text = @"TIMER PAUSED";
    circleTimerStatus.hidden = YES;
    
    // Start Timer.
    AlarmManager *alarmManager = [AppDelegate getDelegate].alarmManager;
    NSInteger numTasks = [alarmManager getRemainTaskCount] + [alarmManager getFinishedTaskCount];
    
    // Setup progress bars.
    progressBars = [NSMutableArray arrayWithCapacity:numTasks];
    mainProgressOriginal = mainProgress;
    [self.view layoutIfNeeded];
    for (NSInteger i = 0; i < numTasks; ++i) {
        CircleProgressBar *progressBar = [[CircleProgressBar alloc] initWithFrame:mainProgress.frame];
        progressBar.hintHidden = mainProgress.hintHidden;
        progressBar.startAngle = mainProgress.startAngle;
        progressBar.progressBarWidth = mainProgress.progressBarWidth;
        progressBar.userInteractionEnabled = NO;
        progressBar.frame = mainProgress.frame;
        
        [progressBar setBackgroundColor:UIColor.clearColor];
        [progressBar setProgressBarTrackColor:UIColor.clearColor];
        [progressBar setProgressBarProgressColor:UIColor.clearColor];
        [progressBars addObject:progressBar];
    }
    
    for (NSInteger i = numTasks - 1; i >= 0; --i) {
        CircleProgressBar *progressBar = progressBars[i];
        [mainProgress.superview addSubview:progressBar];
    }
}

//====================================================================================================
- (void) updateTimerInfo
{
    AlarmManager *alarmManager = [AppDelegate getDelegate].alarmManager;
    
    //Finished.
    lblFisinhed.text = [NSString stringWithFormat: @"FINISHED: %@", [alarmManager getFinishedTaskNames]];
    float currentProgress = [alarmManager getPercentProgress];
    [progressFinished startWithBlock:^CGFloat {
        return currentProgress;
    }];
    
    [mainProgress setProgress:currentProgress animated:YES];
    
    if (shouldAddProgressBar) {
        mainProgress = progressBars[[alarmManager getFinishedTaskCount]];
    }
    
    //Current Task.
    if(currentTimer != nil)
    {
        viewCurrentTask.hidden = NO;
        lblCurrentTaskName.text = currentTimer.name;
        lblCurrentTaskNumber.text = [NSString stringWithFormat: @"%d", [alarmManager getOrderIndex: currentTimer]];
        mainProgress.progressBarProgressColor = currentTimer.color;
    } else {
        // Hide skip, playbutton, and current task if all tasks are finished
        viewCurrentTask.hidden = YES;
        btnPlay.hidden = YES;
        
        // Turn sleep back on if all timers are finished
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
    
    //Next Task.
    Timer* nextTimer = [alarmManager getNextTimer];
    if(nextTimer != nil)
    {
        viewNextTask.hidden = NO;
        lblNextTaskName.text = nextTimer.name;
        lblNextTaskNumber.text = [NSString stringWithFormat: @"%d", [alarmManager getOrderIndex: nextTimer]];
    }
    else
    {
        viewNextTask.hidden = YES;
    }
    
    int finishedCount = [alarmManager getFinishedTaskCount];
    int remainCount = [alarmManager getRemainTaskCount] - 1;
    
    NSString* strFinishedTask = [NSString stringWithFormat: @"%d FINISHED", finishedCount];
    circleFinishedStatus.text = strFinishedTask;
    
    if(remainCount == 0)
    {
        circleAHeadStatus.hidden = YES;
    }
    else
    {
        NSString* strText = [NSString stringWithFormat: @"%@ %d AHEAD", strFinishedTask, remainCount];
        circleAHeadStatus.text = strText;
        [circleAHeadStatus setColor: currentTimer.color];
        circleAHeadStatus.hidden = NO;
        viewStatus.hidden = NO;
    }
    
    //Update InfoBar.
    lblTimeCount.text = [currentTimer getRemainTime];
    lblSecondCount.text = [currentTimer getRemainSecTime];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AlarmManager *alarmManager = [AppDelegate getDelegate].alarmManager;
    if ([alarmManager getRemainTaskCount] > 0) {
        mainProgress = progressBars[[alarmManager getFinishedTaskCount]];
    }
    currentTimer = [alarmManager getCurrentTimer];
    [self updatePauseStatus];
    [self updateTimerInfo];
    
    mainCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(checkTimer)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (CircleProgressBar *progressBar in progressBars) {
        progressBar.frame = mainProgressOriginal.frame;
    }
}

//====================================================================================================
- (IBAction)actionSkip:(id)sender
{
    [self startNextTask:NO];
    [self updateTimerInfo];
}

#pragma mark Check Timer.

//====================================================================================================
- (void) checkTimer
{
    if (bPaused) {
        return;
    }
    
    if (currentTimer != nil) {
        currentTimer.remain_timer--;
        if (currentTimer.remain_timer <= 0)
        {
            [self startNextTask:YES];
        } else {
            lblTimeCount.text = [currentTimer getRemainTime];
            lblSecondCount.text = [currentTimer getRemainSecTime];
        }
        
        [self updateTimerInfo];
    }
}

-(void) startNextTask:(BOOL)playSound {
    currentTimer.status = YES;
    if (playSound) {
        [currentTimer playSound];
    }
    
    AlarmManager *alarmManager = [AppDelegate getDelegate].alarmManager;
    currentTimer = [alarmManager getCurrentTimer];
    [alarmManager saveTimerList];
    
    shouldAddProgressBar = [alarmManager getRemainTaskCount] > 0;
}

//====================================================================================================
- (IBAction) actionPause:(id)sender
{
    bPaused = !bPaused;
    [self updatePauseStatus];
    [[AppDelegate getDelegate].alarmManager saveTimerList];
}

//====================================================================================================
- (void) updatePauseStatus
{
    if(bPaused)
    {
        circleTimerStatus.hidden = NO;
        [btnPlay setImage: [UIImage imageNamed: @"play_button.png"] forState: UIControlStateNormal];
    }
    else
    {
        circleTimerStatus.hidden = YES;
        [btnPlay setImage: [UIImage imageNamed: @"pause_button.png"] forState: UIControlStateNormal];
    }
}

//====================================================================================================
- (IBAction) actionBack:(id)sender
{
    [mainCheckTimer invalidate];
    mainCheckTimer = nil;
    
    // Turn sleep back on when user cancels out of timer
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    // Save and reset the timers for future use
    [[AppDelegate getDelegate].alarmManager resetTimerList];
    [[AppDelegate getDelegate].alarmManager saveTimerList];
    [super actionBack: sender];
}

//====================================================================================================
@end
