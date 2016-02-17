//
//  ColorView.m
//  CoreTimer
//
//  Created by jian on 5/5/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import "ColorView.h"

@implementation ColorView
@synthesize delegate;

//====================================================================================================
+ (id)colorViewWithFrame:(CGRect)frame
{
    // Initialization code
    ColorView* xibView = [[[NSBundle mainBundle] loadNibNamed: @"ColorView" owner:self options:nil] objectAtIndex:0];
    [xibView setFrame:frame];
    [xibView layoutIfNeeded];
    return xibView;
}

//====================================================================================================
- (void) updateColor: (UIColor*) color backgroundColor: (UIColor*) bgColor selected: (BOOL) bSelected
{
    mainColor = color;
    
    self.imgCheck.hidden = !bSelected;
    self.backgroundColor = color;
    self.viewInner.backgroundColor = bgColor;
}

-(void)layoutIfNeeded {
    [super layoutIfNeeded];
    [self updateBorders];
}

- (void) updateBorders
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width / 2.0f;
    self.viewInner.layer.masksToBounds = YES;
    self.viewInner.layer.cornerRadius = self.viewInner.frame.size.width / 2.0f;
}

//====================================================================================================
- (IBAction) actionSelect:(id)sender
{
    self.imgCheck.hidden = NO;
    if ([(id)delegate respondsToSelector:@selector(selectedColor:)])
    {
        [delegate selectedColor:(int)self.tag];
    }
}

//====================================================================================================
- (void) deselectColor
{
    self.imgCheck.hidden = YES;
}

//====================================================================================================
@end
