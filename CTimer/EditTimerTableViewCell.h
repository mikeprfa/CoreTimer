//
//  EditTimerTableViewCell.h
//  CTimer
//
//  Created by jian on 5/6/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditTimerTableViewCellDelegate
@optional
-(void) trashTimer: (int) index;
@end

@interface EditTimerTableViewCell : UITableViewCell
{
    int                 viewIndex;
}
@property (weak, nonatomic) IBOutlet UILabel    *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton   *btnTrash;
@property (weak, nonatomic) IBOutlet UIImageView *imgMenu;
@property (weak, nonatomic) IBOutlet UILabel    *lblNumber;

@property (nonatomic, retain) id                delegate;

- (void) updateTimer: (Timer*) timer view: (int) viewIndex;

@end