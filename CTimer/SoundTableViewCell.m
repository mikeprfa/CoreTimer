//
//  SoundTableViewCell.m
//  CoreTimer
//
//  Created by jian on 5/5/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "SoundTableViewCell.h"

@implementation SoundTableViewCell
@synthesize lblTitle;
@synthesize imgCheck;

//====================================================================================================
- (void)awakeFromNib
{
    // Initialization code
}

//====================================================================================================
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//====================================================================================================
- (void) updateSound: (NSString*) soundName selected: (BOOL) selected
{
    lblTitle.text = soundName;
    imgCheck.hidden = !selected;
}

//====================================================================================================
- (void) deselectSound
{
    imgCheck.hidden = YES;
}

//====================================================================================================
@end
