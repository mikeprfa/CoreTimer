//
//  AddTimerViewController.h
//  CTimer
//
//  Created by jian on 5/2/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIScrollView.h>

@interface AddTimerViewController : BaseViewController <UIScrollViewDelegate>

@property (nonatomic, strong) Timer *timer;
- (void) selectSound: (NSString*) title type: (int) type;
@end
