//
//  RunViewController.m
//  CTimer
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
    NSTimer         *mainCheckTimer;
    Timer           *currentTimer;
    
    BOOL            bPaused;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//====================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
- (void) initMember
{
    [super initMember];
    
    bPaused = NO;
    
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
    
    //Start Timer.
    currentTimer = [[AppDelegate getDelegate].alarmManager getCurrentTimer];
    [self updatePauseStatus];
    [self updateTimerInfo];
    
    mainCheckTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(checkTimer) userInfo: nil repeats: YES];    
}

//====================================================================================================
- (void) updateTimerInfo
{
    //Finished.
    lblFisinhed.text = [NSString stringWithFormat: @"FINISHED: %@", [[AppDelegate getDelegate].alarmManager getFinishedTaskNames]];
    float currentProgress = [[AppDelegate getDelegate].alarmManager getPercentProgress];
    [progressFinished startWithBlock:^CGFloat {
        return currentProgress;
    }];
    
    [mainProgress setProgress: currentProgress animated: YES];
    
    //Current Task.
    if(currentTimer != nil)
    {
        viewCurrentTask.hidden = NO;
        lblCurrentTaskName.text = currentTimer.name;
        lblCurrentTaskNumber.text = [NSString stringWithFormat: @"%d", [[AppDelegate getDelegate].alarmManager getOrderIndex: currentTimer]];
        mainProgress.progressBarProgressColor = currentTimer.color;
    }
    else
    {
        viewCurrentTask.hidden = YES;
    }
    
    //Next Task.
    Timer* nextTimer = [[AppDelegate getDelegate].alarmManager getNextTimer];
    if(nextTimer != nil)
    {
        viewNextTask.hidden = NO;
        lblNextTaskName.text = nextTimer.name;
        lblNextTaskNumber.text = [NSString stringWithFormat: @"%d", [[AppDelegate getDelegate].alarmManager getOrderIndex: nextTimer]];
    }
    else
    {
        viewNextTask.hidden = YES;
    }
    
    int finishedCount = [[AppDelegate getDelegate].alarmManager getFinishedTaskCount];
    int remainCount = [[AppDelegate getDelegate].alarmManager getRemainTaskCount];
    
    NSString* strFinishedTask = [NSString stringWithFormat: @"%d FINISHED", finishedCount];
    circleFinishedStatus.text = strFinishedTask;
    
    if(remainCount == 0)
    {
        circleTimerStatus.hidden = YES;
        circleAHeadStatus.hidden = YES;
        viewStatus.hidden = YES;
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

//====================================================================================================
- (IBAction)actionSkip:(id)sender
{
    currentTimer.status = YES;
    Timer* nextTimer = [[AppDelegate getDelegate].alarmManager getCurrentTimer];
    
    [[AppDelegate getDelegate].alarmManager saveTimerList];
    currentTimer = nextTimer;
    [self updateTimerInfo];
}

#pragma mark Check Timer.

//====================================================================================================
- (void) checkTimer
{
    if(bPaused) return;
    
    if(currentTimer != nil)
    {
        currentTimer.remain_timer --;
        NSLog(@"currentTimer.remain_timer = %d", currentTimer.remain_timer);
        
        if(currentTimer.remain_timer <= 0)
        {
            currentTimer.status = YES;
            [currentTimer playSound];
            
            currentTimer = [[AppDelegate getDelegate].alarmManager getCurrentTimer];
            [[AppDelegate getDelegate].alarmManager saveTimerList];
        }
        else
        {
            lblTimeCount.text = [currentTimer getRemainTime];
            lblSecondCount.text = [currentTimer getRemainSecTime];
        }
        
        [self updateTimerInfo];
    }
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
    
    [[AppDelegate getDelegate].alarmManager resetTimerList];
    [[AppDelegate getDelegate].alarmManager saveTimerList];
    [super actionBack: sender];
}

//====================================================================================================
@end
