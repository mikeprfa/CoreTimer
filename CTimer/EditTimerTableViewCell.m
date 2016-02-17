//
//  EditTimerTableViewCell.m
//  CoreTimer
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
- (void) updateTimer: (Timer*) timer
{
    NSString* real_time = [NSString stringWithFormat: @"%@", [Timer getTimeFormat: timer.timer]];
    NSString* title = [NSString stringWithFormat: @"%@ %@", real_time, timer.name];
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];

    lblTitle.text = title;
    NSMutableAttributedString * attriString = [[NSMutableAttributedString alloc] initWithString: title];
    [attriString addAttribute:NSFontAttributeName value: boldFont range:(NSMakeRange(0, [real_time length]))];
    lblTitle.attributedText = attriString;

    btnTrash.hidden = YES;
    imgMenu.hidden = YES;
    lblNumber.hidden = NO;
}

-(void)setTag:(NSInteger)tag
{
    if (tag != self.tag || [lblNumber.text isEqualToString:@""]) {
        lblNumber.text = [NSString stringWithFormat: @"%d", (int)tag + 1];
    }
    [super setTag:tag];
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
