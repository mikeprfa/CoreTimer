//
//  SettingsViewController.m
//  CoreTimer
//
//  Created by jian on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *swUseDelay;
@property (weak, nonatomic) IBOutlet UISwitch *swColorEntire;

@end

@implementation SettingsViewController
@synthesize swColorEntire;
@synthesize swUseDelay;

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
- (void) viewWillAppear:(BOOL)animated
{
//    swUseDelay.on = [AppDelegate getDelegate].alarmManager.useDelay;
//    swColorEntire.on = [AppDelegate getDelegate].alarmManager.colorEntireBackground;
}

//====================================================================================================
- (IBAction) actionBack:(id)sender
{
    /*
    BOOL bChangedDelay = NO;
    if([AppDelegate getDelegate].alarmManager.useDelay != swUseDelay.on)
    {
        bChangedDelay = YES;
    }
    
    [AppDelegate getDelegate].alarmManager.useDelay = swUseDelay.on;
    [AppDelegate getDelegate].alarmManager.colorEntireBackground = swColorEntire.on;
    [[AppDelegate getDelegate].alarmManager saveSettingsInfo];
    
    if(bChangedDelay)
    {
        [[AppDelegate getDelegate].alarmManager rescheduleTimers];
    }
    */
    
    [super actionBack: sender];
}

//====================================================================================================
@end
