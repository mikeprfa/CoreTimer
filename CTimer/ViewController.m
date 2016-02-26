//
//  ViewController.m
//  CoreTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "ViewController.h"
#import "AddTimerViewController.h"
#import "EditTimerTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL            bExistTimer;
}

@property (weak, nonatomic) IBOutlet UIView      *viewEmpty;
@property (weak, nonatomic) IBOutlet UILabel     *lblEmptyTimer;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmptyTimer;
@property (weak, nonatomic) IBOutlet UIView      *viewFill;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIButton    *btnStart;
@property (weak, nonatomic) IBOutlet UIButton    *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton    *btnAddTimer;
- (IBAction)actionStart:(id)sender;

@end

@implementation ViewController
@synthesize lblEmptyTimer;
@synthesize imgEmptyTimer;
@synthesize viewEmpty;
@synthesize viewFill;
@synthesize tblView;
@synthesize btnStart;
@synthesize btnEdit;

//====================================================================================================

- (void) viewDidLoad{
    [super viewDidLoad];
}
- (void) setup
{
    [super setup];
    
    btnStart.layer.masksToBounds = YES;
    btnStart.layer.cornerRadius = btnStart.frame.size.height / 2.0f;
    
    [tblView registerNib:[UINib nibWithNibName:@"EditTimerTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditTimerTableViewCell"];
}

- (void) setupEmptyView {
    if([[AppDelegate getDelegate].alarmManager.arrList count] > 0)
    {
        bExistTimer = YES;
        viewEmpty.hidden = YES;
        viewFill.hidden = NO;
        btnEdit.hidden = NO;
    }
    else
    {
        bExistTimer = NO;
        viewEmpty.hidden = NO;
        viewFill.hidden = YES;
        btnEdit.hidden = YES;
    }
}

//====================================================================================================
- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: animated];
    
    [self setupEmptyView];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [tblView setContentInset:UIEdgeInsetsMake(120,0,0,0)];
    
    [tblView reloadData];
    
    
}

//====================================================================================================
- (IBAction) actionAddTimer:(id)sender
{
    if (!tblView.isEditing) {
        UIStoryboard *storyboard = nil;;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        else
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        id nextView = [storyboard instantiateViewControllerWithIdentifier: @"AddTimerViewController"];
        [self.navigationController pushViewController: nextView animated: YES];
    }
}

//====================================================================================================
- (IBAction) actionEdit:(id)sender
{
    if (tblView.isEditing) {
        [tblView setEditing:NO animated:YES];
    } else {
        if (bExistTimer)
        {
            [tblView setEditing:YES animated:YES];
        }
    }
    [self updateButtons];
}

-(void) updateButtons {
    if (!bExistTimer && tblView.isEditing) {
        [tblView setEditing:NO animated:NO];
    }
    
    if (tblView.isEditing) {
        [self.btnEdit setTitle:NSLocalizedString(@"Done", nil)
                      forState:UIControlStateNormal];
        self.btnEdit.hidden = NO;
        self.btnAddTimer.hidden = YES;
        self.btnStart.hidden = YES;
    } else {
        [self.btnEdit setTitle:NSLocalizedString(@"Edit", nil)
                      forState:UIControlStateNormal];
        self.btnAddTimer.hidden = NO;
        self.btnStart.hidden = NO;
    }
    
    if (bExistTimer) {
        self.btnEdit.hidden = NO;
    } else {
        self.btnEdit.hidden = YES;
    }
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
    return 65.0f;
}

//====================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AppDelegate getDelegate].alarmManager.arrList count];
}

//====================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditTimerTableViewCell *cell = (EditTimerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EditTimerTableViewCell"];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    AlarmManager *alarmManager = [AppDelegate getDelegate].alarmManager;
    Timer *timer = [alarmManager.arrList objectAtIndex: indexPath.row];
    [cell updateTimer:timer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self trashTimer:indexPath.row];
    }
    // This method intentionally left blank.
}

-(NSArray *)tableView:(UITableView *)tableView
editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button1 =
    [UITableViewRowAction
     rowActionWithStyle:UITableViewRowActionStyleDestructive
     title:@"Delete"
     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self trashTimer:indexPath.row];
     }];
    
    UITableViewRowAction *button2 =
    [UITableViewRowAction
     rowActionWithStyle:UITableViewRowActionStyleDefault
     title:@"Edit"
     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self editTimer:indexPath.row];
     }];
    button2.backgroundColor = UIColor.orangeColor;
    
    return @[button1, button2];
}

//====================================================================================================
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    AlarmManager *alarmManager = [AppDelegate getDelegate].alarmManager;
    NSMutableArray *timers = alarmManager.arrList;
    NSUInteger from = sourceIndexPath.row;
    NSUInteger to = destinationIndexPath.row;
    
    Timer *timerFrom = [timers objectAtIndex:from];
    [timers removeObjectAtIndex:from];
    [timers insertObject:timerFrom atIndex:to];

    [tableView reloadData];
}

- (void) editTimer:(NSInteger)index
{
    UIStoryboard *storyboard = nil;;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddTimerViewController *nextView = (AddTimerViewController *)[storyboard
      instantiateViewControllerWithIdentifier: @"AddTimerViewController"];
    
    Timer *timer = [[AppDelegate getDelegate]
                    .alarmManager.arrList objectAtIndex:index];
    nextView.timer = timer;
    [self.navigationController pushViewController: nextView animated: YES];
}

- (void) trashTimer:(NSInteger) index {
    [[AppDelegate getDelegate].alarmManager.arrList removeObjectAtIndex: index];
    [[AppDelegate getDelegate].alarmManager saveTimerList];
    [tblView reloadData];
    [self setupEmptyView];
    [self updateButtons];
}

//====================================================================================================
- (IBAction)actionStart:(id)sender {
    UIStoryboard *storyboard = nil;;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UIViewController *vc = [storyboard
        instantiateViewControllerWithIdentifier:@"RunViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end