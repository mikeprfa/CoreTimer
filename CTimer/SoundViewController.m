//
//  SonudViewController.m
//  CTimer
//
//  Created by jian on 5/5/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import "SoundViewController.h"
#import "Timer.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SoundTableViewCell.h"
#import "AddTimerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SoundViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray                     *arrSounds;
    int                         selectedIndex;
    
    AVAudioPlayer               *player;
}

@property (nonatomic, weak) IBOutlet UITableView            *tblView;

@end

@implementation SoundViewController
@synthesize tblView;

//====================================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//====================================================================================================
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
- (void) initMember
{
    [super initMember];
    
    selectedIndex = 0;
    arrSounds = @[@"Note (default)", @"Bells", @"Classic", @"Digital", @"Paradise", @"Piano", @"Radar", @"ringtone", @"Silk", @"Singing_Birds", @"Sweet_Day", @"Tayde", @"Trumpets", @"Workout"];
    
    
    [tblView registerNib:[UINib nibWithNibName:@"SoundTableViewCell" bundle:nil] forCellReuseIdentifier:@"SoundTableViewCell"];
}

//====================================================================================================
- (IBAction) actionBack:(id)sender
{
    NSString* title = [arrSounds objectAtIndex:selectedIndex];
    [(AddTimerViewController*)self.parentView selectSound: title
                                                     type: self.type];
    [super actionBack: sender];
}

#pragma mark - Table view data source

//====================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//====================================================================================================
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.0f;
}

//====================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSounds count];
}

//====================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SoundTableViewCell *cell = (SoundTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SoundTableViewCell"];
    cell.tag = indexPath.row;
    if(indexPath.row == selectedIndex)
    {
        [cell updateSound: [arrSounds objectAtIndex: indexPath.row] selected: YES];
    }
    else
    {
        [cell updateSound: [arrSounds objectAtIndex: indexPath.row] selected: NO];
    }
    
    return cell;
}

//====================================================================================================
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        
    }
    else
    {

        NSString* path = [[NSBundle mainBundle] pathForResource: [arrSounds objectAtIndex: indexPath.row] ofType:@"caf"];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error: nil];
        [player play];
    }
    
    selectedIndex = (int)indexPath.row;
    [tblView reloadData];
}

//====================================================================================================
@end
