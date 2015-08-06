//
//  EditTimerTableViewCell.m
//  CTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "EditTimerTableViewCell.h"

@implementation EditTimerTableViewCell
@synthesize delegate;
@synthesize lblTitle;
@synthesize btnTrash;
@synthesize imgMenu;
@synthesize lblNumber;

//====================================================================================================
- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

//====================================================================================================
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//====================================================================================================
- (void) updateTimer: (Timer*) timer view: (int) index
{
    viewIndex = index;
    NSString* real_time = [NSString stringWithFormat: @"%@", [Timer getTimeFormat: timer.timer]];
    NSString* title = [NSString stringWithFormat: @"%@ %@", real_time, timer.name];
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];

    lblTitle.text = title;
    NSMutableAttributedString * attriString = [[NSMutableAttributedString alloc] initWithString: title];
    [attriString addAttribute:NSFontAttributeName value: boldFont range:(NSMakeRange(0, [real_time length]))];
    lblTitle.attributedText = attriString;
    
    if(index == VIEW_MAIN)
    {
        btnTrash.hidden = YES;
        imgMenu.hidden = YES;
        lblNumber.hidden = NO;
        lblNumber.text = [NSString stringWithFormat: @"%d", (int)self.tag + 1];
    }
    else
    {
        btnTrash.hidden = NO;
        imgMenu.hidden = NO;
        lblNumber.hidden = YES;
    }
}

//====================================================================================================
- (IBAction)actionTrash:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(trashTimer:)])
    {
        [delegate trashTimer: (int)self.tag];
    }
}

//====================================================================================================
@end
