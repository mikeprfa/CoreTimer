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
    
    int                             selectedColorIndex;
    int                             timerInputMode;
    
    Timer                           *newTimer;
}

@property (nonatomic, weak) IBOutlet UIView                 *viewTimerName;
@property (nonatomic, weak) IBOutlet UITextField            *txtTimerName;
@property (nonatomic, weak) IBOutlet UIScrollView           *scrollColor;
@property (nonatomic, weak) IBOutlet UIView                 *viewTimer;
@property (nonatomic, weak) IBOutlet UILabel                *lblTimer;
@property (nonatomic, weak) IBOutlet UILabel                *lblTimeMusic;

//Timer Picker;
@property (nonatomic, weak) IBOutlet UIView                 *viewTimerPicker;
@property (nonatomic, weak) IBOutlet UIBarButtonItem        *btnTitle;
@property (nonatomic, weak) IBOutlet UIPickerView           *picker;

@end

@implementation AddTimerViewController
@synthesize txtTimerName;
@synthesize viewTimerName;
@synthesize viewTimer;
@synthesize scrollColor;

@synthesize viewTimerPicker;
@synthesize btnTitle;
@synthesize picker;

@synthesize lblTimeMusic;
@synthesize lblTimer;

//====================================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//====================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
- (void) initMember
{
    [super initMember];
    
    newTimer = [[Timer alloc] init];
    
    realTime = DEFAULT_TIMER_VALUE;
    lblTimeMusic.text = @"Note (default)";
    newTimer.timer_music = lblTimeMusic.text;

    lblTimer.text = [NSString stringWithFormat: @"%d sec", realTime];
    
    selectedColorIndex = 0;
    arrColors = [NSArray arrayWithObjects: [UIColor colorWithRed: 252.0f/255.0f green: 150.0f/255.0f blue: 3.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 0/255.0f green: 246.0f/255.0f blue: 235.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 0.0f/255.0f green: 187.0f/255.0f blue: 226.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 255.0f/255.0f green: 0.0f/255.0f blue: 0.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 0.0f/255.0f green: 255.0f/255.0f blue: 0.0f/255.0 alpha: 1.0f],
                 [UIColor colorWithRed: 0.0f/255.0f green: 0.0f/255.0f blue: 255.0f/255.0 alpha: 1.0f],
                 nil];
    arrColorCells = [[NSMutableArray alloc] init];
    
    arrTimer = [[NSMutableArray alloc] init];
    NSMutableArray* arrHours = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 12; i++)
    {
        [arrHours addObject: [NSString stringWithFormat: @"%d", i]];
    }

    NSMutableArray* arrMinues = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 59; i++)
    {
        [arrMinues addObject: [NSString stringWithFormat: @"%02i", i]];
    }
    
    NSMutableArray* arrSecs = [[NSMutableArray alloc] init];
    for(int i = 0; i <= 59; i++)
    {
        [arrSecs addObject: [NSString stringWithFormat: @"%02i", i]];
    }
    [arrTimer addObject: arrHours];
    [arrTimer addObject: arrMinues];
    [arrTimer addObject: arrSecs];
    
    viewTimerName.layer.masksToBounds = YES;
    viewTimerName.layer.cornerRadius = viewTimerName.frame.size.height / 2.0f;
    viewTimerName.layer.borderWidth = 1.0f;
    viewTimerName.layer.borderColor = MAIN_TEXT_COLOR.CGColor;
    
    viewTimer.layer.masksToBounds = YES;
    viewTimer.layer.cornerRadius = viewTimer.frame.size.height / 2.0f;
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
    [arrColorCells removeAllObjects];
    for(UIView* view in scrollColor.subviews)
    {
        [view removeFromSuperview];
    }
    
    float fx = 12;
    float fy = 0;
    float fw = 170.0f;
    float fh = 170.0f;
    float fIndentX = 12;
    
    for(int i = 0; i < [arrColors count]; i++)
    {
        UIColor* color = [arrColors objectAtIndex: i];
        ColorView* view = [[ColorView alloc] initWithFrame: CGRectMake(fx, fy, fw, fh)];
        
        if(selectedColorIndex == i)
        {
            [view updateColor: color backgroundColor: self.view.backgroundColor selected: YES];
        }
        else
        {
            [view updateColor: color backgroundColor: self.view.backgroundColor selected: NO];
        }
        view.delegate = self;
        view.tag = i;
       
        [scrollColor addSubview: view];
        [arrColorCells addObject: view];
        
        fx += (fw + fIndentX);
    }
    
    [scrollColor setContentSize: CGSizeMake(fx, scrollColor.contentSize.height)];
}

//====================================================================================================
- (void) selectedColor:(int)index
{
    selectedColorIndex = index;
    for(ColorView* cellView in arrColorCells)
    {
        if(cellView.tag != index)
        {
            [cellView deselectColor];
        }
    }
}

//====================================================================================================
- (IBAction)actionTimerMusic:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SoundViewController* nextView = (SoundViewController*)[storyboard instantiateViewControllerWithIdentifier: @"SoundViewController"];
    nextView.parentView = self;
    nextView.type = TIMER_REAL;
    
    if(lblTimeMusic.text != nil && [lblTimeMusic.text length] > 0)
    {
        nextView.selectedSoundName = lblTimeMusic.text;
    }

    [self.navigationController pushViewController: nextView animated: YES];
}

//====================================================================================================
- (void) selectSound: (NSString*) title type: (int) type
{
    lblTimeMusic.text = title;
    newTimer.timer_music = title;
}

//====================================================================================================
- (IBAction)actionTimer:(id)sender
{
    timerInputMode = TIMER_REAL;
    btnTitle.title = @"Please set timer";
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
    viewTimerPicker.hidden = YES;
}

//====================================================================================================
- (void) preselectPicker: (int) time
{
    int hour = (time / 3600);
    int minute = (time % 3600) / 60;
    int sec = time % 60;
    
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
    
    realTime = hour * 3600 + minute * 60 + sec;
    lblTimer.text = [Timer getTimerValue: hour minute: minute sec: sec];
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
    
    newTimer.name = name;
    newTimer.color = [arrColors objectAtIndex: selectedColorIndex];
    newTimer.timer = realTime;
    newTimer.remain_timer = realTime;    
    newTimer.status = NO;
    newTimer.createdAt = [NSDate date];

    [[AppDelegate getDelegate].alarmManager addTimer: newTimer];
    [[AppDelegate getDelegate].alarmManager saveTimerList];
    
    [self actionBack: nil];
}
//====================================================================================================
@end
