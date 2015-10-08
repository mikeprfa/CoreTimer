//
//  AddTimerViewController.m
//  CTimer
//
//  Created by jian on 5/2/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import "AddTimerViewController.h"
#import "ColorView.h"
#import "Timer.h"
#import "SoundViewController.h"

@interface AddTimerViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ColorViewDelegate>
{
    NSMutableArray                  *arrTimer;
    NSArray                         *arrColors;
    NSMutableArray                  *arrColorCells;
    
    int                             realTime;
    int                             realTimeTmp;
    
    NSInteger                       selectedColorIndex;
    int                             timerInputMode;
    
    BOOL                            colorBarInitialized;
    BOOL                            scrollWheelInitialized;
    BOOL                            isEditingExistingTimer;
}

@property (nonatomic, weak) IBOutlet UIView                 *viewTimerName;
@property (nonatomic, weak) IBOutlet UITextField            *txtTimerName;
@property (nonatomic, weak) IBOutlet UIScrollView           *scrollColor;
@property (nonatomic, weak) IBOutlet UIButton               *lblTimer;
@property (nonatomic, weak) IBOutlet UIButton               *btnTimer;

//Timer Picker;
@property (nonatomic, weak) IBOutlet UIView                 *viewTimerPicker;
@property (nonatomic, weak) IBOutlet UIBarButtonItem        *btnTitle;
@property (nonatomic, weak) IBOutlet UIPickerView           *picker;

@end

@implementation AddTimerViewController
@synthesize txtTimerName;
@synthesize viewTimerName;
@synthesize scrollColor;
@synthesize timer = timer;

@synthesize viewTimerPicker;
@synthesize btnTitle;
@synthesize btnTimer;
@synthesize picker;

@synthesize lblTimer;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupScrollView];
}

- (void) setupScrollView {
    if (!scrollWheelInitialized) {
        CGFloat inset = [self scrollViewInset];
        CGFloat offset = [self cellOffsetForIndex:0];
        scrollColor.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
        scrollColor.contentOffset = CGPointMake(offset, 0);
        scrollWheelInitialized = YES;
    }
}

- (BOOL) color:(UIColor *)color1 isEqualTo:(UIColor *)color2 {
    const CGFloat *components1 = CGColorGetComponents(color1.CGColor);
    const CGFloat *components2 = CGColorGetComponents(color2.CGColor);
    for (int i = 0; i < CGColorGetNumberOfComponents(color1.CGColor); ++i) {
        if (fabs(components1[i] - components2[i]) > 1e-3) {
            return NO;
        }
    }
    return YES;
}

//====================================================================================================
- (void) setup
{
    [super setup];

    if (!timer) {
        timer = [[Timer alloc] init];
        isEditingExistingTimer = NO;
    } else {
        isEditingExistingTimer = YES;
    }
    
    if (!isEditingExistingTimer) {
        realTime = realTimeTmp = DEFAULT_TIMER_VALUE;
        NSString *defaultSound = @"Air Horn";
        timer.timer_music = defaultSound;
    } else {
        realTime = realTimeTmp = timer.timer;
        txtTimerName.text = timer.name;
    }
    [btnTimer setTitle:timer.timer_music forState:UIControlStateNormal];
    
    int seconds = realTime % 60;
    int minutes = (realTime/60) % 60;
    int hours = realTime/(60*60);

    NSAttributedString *title = [Timer getTimerValue:hours
                                              minute:minutes
                                                 sec:seconds];
    [lblTimer setAttributedTitle:title
                        forState:UIControlStateNormal];

    arrColors = [NSArray arrayWithObjects: [UIColor colorWithRed: 252.0f/255.0f green: 150.0f/255.0f blue: 3.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 0.0f/255.0f green: 246.0f/255.0f blue: 235.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 0.0f/255.0f green: 187.0f/255.0f blue: 226.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 248.0f/255.0f green: 57.0f/255.0f blue: 98.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 188.0f/255.0f green: 216.0f/255.0f blue: 0.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 255.0f/255.0f green: 250.0f/255.0f blue: 240.0f/255.0 alpha: 1.0f],
                 nil];
    arrColorCells = [[NSMutableArray alloc] init];
    selectedColorIndex = 0;
    for (NSInteger i = 0; i < arrColors.count; ++i) {
        if ([self color:timer.color isEqualTo:arrColors[i]]) {
            selectedColorIndex = i;
            scrollWheelInitialized = NO;
            break;
        }
    }
    [self setupScrollView];
    
    arrTimer = [[NSMutableArray alloc] init];
    NSMutableArray* arrHours = [[NSMutableArray alloc] init];
    [arrHours addObject:@"Hours"];
    for(int i = 0; i <= 12; i++)
    {
        [arrHours addObject: [NSString stringWithFormat: @"%d", i]];
    }

    NSMutableArray* arrMinutes = [[NSMutableArray alloc] init];
    [arrMinutes addObject:@"Minutes"];
    for(int i = 0; i <= 59; i++)
    {
        [arrMinutes addObject: [NSString stringWithFormat: @"%02i", i]];
    }
    
    NSMutableArray* arrSecs = [[NSMutableArray alloc] init];
    [arrSecs addObject:@"Seconds"];
    for(int i = 0; i <= 59; i++)
    {
        [arrSecs addObject: [NSString stringWithFormat: @"%02i", i]];
    }
    [arrTimer addObject: arrHours];
    [arrTimer addObject: arrMinutes];
    [arrTimer addObject: arrSecs];
    
    viewTimerName.layer.masksToBounds = YES;
    viewTimerName.layer.cornerRadius = viewTimerName.frame.size.height / 2.0f;
    viewTimerName.layer.borderWidth = 1.0f;
    viewTimerName.layer.borderColor = MAIN_TEXT_COLOR.CGColor;
    
    [lblTimer setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [lblTimer setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    lblTimer.layer.cornerRadius = lblTimer.frame.size.height / 2.0f;
}

//====================================================================================================
- (void) viewWillLayoutSubviews
{
    [self initColorBar];
}

#pragma mark - Color.
//====================================================================================================
- (void) initColorBar
{
    if (colorBarInitialized) {
        return;
    }
    colorBarInitialized = YES;

    [arrColorCells removeAllObjects];
    for(UIView* view in scrollColor.subviews)
    {
        [view removeFromSuperview];
    }
    
    CGFloat fx = 0;
    CGFloat fy = 0;
    CGFloat fw = self.btnTimer.frame.size.width;
    CGFloat fh = fw;
    CGFloat fIndentX = 12;
    
    for (int i = 0; i < [arrColors count]; i++)
    {
        UIColor* color = [arrColors objectAtIndex: i];
        ColorView* view = [ColorView colorViewWithFrame:CGRectMake(fx, fy, fw, fh)];
        
        if(selectedColorIndex == i)
        {
            [view updateColor: color backgroundColor: self.view.backgroundColor selected: YES];
        } else {
            [view updateColor: color backgroundColor: self.view.backgroundColor selected: NO];
        }
        view.delegate = self;
        view.tag = i;
       
        [scrollColor addSubview: view];
        [arrColorCells addObject: view];
        
        fx += (fw + fIndentX);
    }
    
    [scrollColor setContentSize: CGSizeMake(fx, scrollColor.contentSize.height)];
    CGFloat offset = [self cellOffsetForIndex:selectedColorIndex];
    scrollColor.contentOffset = CGPointMake(offset, 0);
}

//====================================================================================================
- (void) selectedColor:(NSInteger) index
{
    index = MAX(0, MIN(arrColorCells.count - 1, index));
    selectedColorIndex = index;
    for(ColorView* cellView in arrColorCells)
    {
        if(cellView.tag != index)
        {
            [cellView deselectColor];
        }
    }
    
    CGPoint contentOffset = CGPointMake([self cellOffsetForIndex:index], 0);
    [scrollColor setContentOffset:contentOffset
                         animated:YES];
}

//====================================================================================================
- (IBAction)actionTimerMusic:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SoundViewController* nextView = (SoundViewController*)[storyboard instantiateViewControllerWithIdentifier: @"SoundViewController"];
    nextView.parentView = self;
    nextView.type = TIMER_REAL;
    
    NSString *music = [btnTimer titleForState:UIControlStateNormal];
    if(music != nil && [music length] > 0)
    {
        nextView.selectedSoundName = music;
    }

    [self.navigationController pushViewController: nextView animated: YES];
}

//====================================================================================================
- (void) selectSound: (NSString*) title type: (int) type
{
    timer.timer_music = title;
    [btnTimer setTitle:title forState:UIControlStateNormal];
}

//====================================================================================================
- (IBAction)actionTimer:(id)sender
{
    timerInputMode = TIMER_REAL;
    btnTitle.title = @"Please set the timer";
    viewTimerPicker.hidden = NO;
    
    [self preselectPicker: realTime];
}

//====================================================================================================
- (IBAction) actionCancelTimer:(id)sender
{
    viewTimerPicker.hidden = YES;
}

//====================================================================================================
- (IBAction) actionDoneTimer:(id)sender
{
    int sec = realTimeTmp % 60;
    int minute = (realTimeTmp/60) % 60;
    int hour = (realTimeTmp / (60 * 60));
    [lblTimer setAttributedTitle:[Timer getTimerValue: hour minute: minute sec: sec]
                        forState:UIControlStateNormal];
    realTime = realTimeTmp;
    
    viewTimerPicker.hidden = YES;
}

//====================================================================================================
- (void) preselectPicker: (int) time
{
    // The first items in the picker are the labels.
    int hour = 1 + (time / 3600);
    int minute = 1 + (time % 3600) / 60;
    int sec = 1 + time % 60;
    [picker selectRow: hour inComponent: 0 animated: YES];
    [picker selectRow: minute inComponent: 1 animated: YES];
    [picker selectRow: sec inComponent: 2 animated: YES];    
}

#pragma mark - UITextField Delegate.

//====================================================================================================
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 
#pragma mark UIPicker Delegate.

//====================================================================================================
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//====================================================================================================
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[arrTimer objectAtIndex: component] count];
}

//====================================================================================================
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[arrTimer objectAtIndex: component] objectAtIndex: row];
}

//====================================================================================================
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGRect rowFrame = CGRectMake(0.0f, 0.0f, [pickerView viewForRow:row forComponent:component].frame.size.width, [pickerView viewForRow:row forComponent:component].frame.size.height);
    UILabel *label = [[UILabel alloc] initWithFrame:rowFrame];
    label.font = [UIFont systemFontOfSize: 18.0f];
    
    // This is an array I pass to the picker in prepareForSegue:sender:
    label.text = [[arrTimer objectAtIndex: component] objectAtIndex: row];
    
    if(component == 0)
    {
        label.textAlignment = NSTextAlignmentRight;
    }
    else if(component == 1)
    {
        label.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        label.textAlignment = NSTextAlignmentLeft;
    }
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

//====================================================================================================
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger selectedRow1 = [pickerView selectedRowInComponent: 0];
    NSUInteger selectedRow2 = [pickerView selectedRowInComponent: 1];
    NSUInteger selectedRow3 = [pickerView selectedRowInComponent: 2];
    
    int hour = [[[arrTimer objectAtIndex: 0] objectAtIndex: selectedRow1] intValue];
    int minute = [[[arrTimer objectAtIndex: 1] objectAtIndex: selectedRow2] intValue];
    int sec = [[[arrTimer objectAtIndex: 2] objectAtIndex: selectedRow3] intValue];
    
    realTimeTmp = hour * 3600 + minute * 60 + sec;
    if (realTimeTmp == 0) {
        realTimeTmp = 30;
    }
}

//====================================================================================================
- (IBAction)actionDone:(id)sender
{
    NSString* name = txtTimerName.text;
    if(name == nil || [name length] == 0)
    {
        [[AppDelegate getDelegate] showMessage: MSG_INVALID_TIMER_NAME];
        return;
    }
    
    if(realTime == 0)
    {
        [[AppDelegate getDelegate] showMessage: MSG_INVALID_TIMER_INTERVAL];
        return;
    }
    
    timer.name = name;
    timer.color = [arrColors objectAtIndex: selectedColorIndex];
    timer.timer = realTime;
    timer.remain_timer = realTime;
    timer.status = NO;
    timer.createdAt = [NSDate date];

    if (!isEditingExistingTimer) {
        // We are not editing - we are creating a timer.
        [[AppDelegate getDelegate].alarmManager addTimer: timer];
    }
    [[AppDelegate getDelegate].alarmManager saveTimerList];
    
    [self actionBack: nil];
}
//====================================================================================================

-(CGFloat) cellWidth {
    return self.btnTimer.frame.size.width;
}

- (float) scrollViewInset {
    return (self.view.frame.size.width - self.cellWidth) / 2.0;
}

- (float) cellOffsetForIndex:(NSInteger) index {
    index = MAX(0, MIN(arrColorCells.count - 1, index));
    CGFloat cellWidth = self.cellWidth;
    CGFloat fIndentX = 12;
    CGFloat inset = self.scrollViewInset;
    return -inset + index * (cellWidth + fIndentX);
}

-(NSInteger) cellIndexAtOffset:(CGFloat) offset {
    CGFloat cellWidth = self.cellWidth;
    offset = offset - self.scrollViewInset;
    NSInteger cellIndex = floor(MAX(0, offset) / cellWidth);
    cellIndex = MIN(arrColorCells.count - 1, MAX(0, cellIndex));
    
    // Round to the next cell if the scrolling will stop over halfway to the next cell.
    if ((offset - [self cellOffsetForIndex:cellIndex]) > cellWidth / 2) {
        ++cellIndex;
    }

    return cellIndex;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (ColorView *colorView in arrColorCells) {
        colorView.imgCheck.hidden = YES;
    }
    
    NSInteger cellIndex = [self cellIndexAtOffset:scrollView.contentOffset.x];
    ColorView *colorView = arrColorCells[cellIndex];
    selectedColorIndex = cellIndex;
    colorView.imgCheck.hidden = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // Determine which table cell the scrolling will stop on.
    NSInteger cellIndex = [self cellIndexAtOffset:targetContentOffset->x];
    
    // Adjust stopping point to exact beginning of cell.
    targetContentOffset->x = [self cellOffsetForIndex:cellIndex];
}

@end
