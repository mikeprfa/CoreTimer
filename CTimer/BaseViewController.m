//
//  BaseViewController.m
//  CTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

//====================================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

//====================================================================================================
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//====================================================================================================
- (void) setup
{
    
}

//====================================================================================================
- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

//====================================================================================================
@end