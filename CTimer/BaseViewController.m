//
//  BaseViewController.m
//  CTimer
//
//  Created by jian on 5/2/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

//====================================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMember];
}

//====================================================================================================
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//====================================================================================================
- (void) initMember
{
    
}

//====================================================================================================
- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

//====================================================================================================
@end
