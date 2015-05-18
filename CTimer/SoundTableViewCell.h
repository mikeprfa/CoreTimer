//
//  SoundTableViewCell.h
//  CTimer
//
//  Created by jian on 5/5/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundTableViewCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UILabel        *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView    *imgCheck;

- (void) updateSound: (NSString*) soundName selected: (BOOL) selected;
- (void) deselectSound;
@end
