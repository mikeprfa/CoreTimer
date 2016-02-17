//
//  ColorView.h
//  CoreTimer
//
//  Created by jian on 5/5/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorViewDelegate
@optional
-(void) selectedColor: (NSInteger) index;
@end

@interface ColorView : UIView
{
    UIColor                 *mainColor;
}

@property (nonatomic, weak) IBOutlet UIImageView        *imgCheck;
@property (nonatomic, weak) IBOutlet UIView             *viewInner;
@property (nonatomic, retain) id                        delegate;

+ (id) colorViewWithFrame:(CGRect)frame;
- (void) updateColor: (UIColor*) color backgroundColor: (UIColor*) bgColor selected: (BOOL) bSelected;
- (void) deselectColor;

@end
