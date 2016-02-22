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
    NSInteger                   selectedIndex;
    
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
- (void) setup
{
    [super setup];
    
    selectedIndex = 0;
    arrSounds = @[@"Air Horn", @"Alarm Clock", @"Alien Siren", @"Car Alarm Activating", @"Church Bells", @"Cuckoo", @"Drum", @"Gobble", @"Midnight", @"Morse", @"Music Box", @"Pager", @"Reveille", @"Siren", @"Toy Train", @"Trumpet Voice"];
    
    NSInteger index = 0;
    if (_selectedSoundName.length > 0) {
        for (NSString *sound in arrSounds) {
            if ([sound isEqualToString:_selectedSoundName]) {
                selectedIndex = index;
                break;
            }
            ++index;
        }
    }
    
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
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
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

    NSString* path = [[NSBundle mainBundle] pathForResource: [arrSounds objectAtIndex: indexPath.row] ofType:@"caf"];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path] error: nil];
    [player play];

    selectedIndex = (int)indexPath.row;
    [tblView reloadData];
}

//====================================================================================================
@end

