//
//  ViewController.m
//  CTimer
//
//  Created by jian/Matei on 5/2/15.
//  Copyright (c) 2015 RockFlowers Apps, LLC. All rights reserved.
//

#import "ViewController.h"
#import "EditViewController.h"
#import "AddTimerViewController.h"
#import "EditTimerTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL            bExistTimer;
}

@property (weak, nonatomic) IBOutlet UIView                 *viewEmpty;
@property (weak, nonatomic) IBOutlet UILabel                *lblEmptyTimer;
@property (weak, nonatomic) IBOutlet UIImageView            *imgEmptyTimer;
@property (weak, nonatomic) IBOutlet UIView                 *viewFill;
@property (weak, nonatomic) IBOutlet UITableView            *tblView;
@property (weak, nonatomic) IBOutlet UIButton               *btnStart;
@property (weak, nonatomic) IBOutlet UIButton               *btnEdit;

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
    
    [tblView setContentInset:UIEdgeInsetsMake(120,0,0,0)];
    
    [tblView reloadData];
}

//====================================================================================================
- (IBAction) actionAddTimer:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id nextView = [storyboard instantiateViewControllerWithIdentifier: @"AddTimerViewController"];
    [self.navigationController pushViewController: nextView animated: YES];
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
    [cell updateTimer: [[AppDelegate getDelegate].alarmManager.arrList objectAtIndex: indexPath.row] view: VIEW_MAIN];
    
    return cell;
}

/*
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *test1;
    UITableViewRowAction *test2;
    UITableViewRowAction *test3;
    test1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                              title:@"Test"
                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                NSLog(@"RowAction Handler: %@ %@", action, indexPath);
                                            }];
    test2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                               title:@"Test2"
                                             handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                 NSLog(@"RowAction Handler: %@ %@", action, indexPath);
                                             }];
    test3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                               title:@"Test3"
                                             handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                 NSLog(@"RowAction Handler: %@ %@", action, indexPath);
                                             }];
    return @[ test1, test2, test3 ];
}
 */

- (void)tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self trashTimer:indexPath.row];
    }
    
    // This method intentionally left blank.
    // More info: http://pablin.org/2014/09/25/uitableviewrowaction-introduction/
}

//====================================================================================================
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[AppDelegate getDelegate].alarmManager.arrList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

//====================================================================================================
- (void) trashTimer:(NSInteger)index
{
    [[AppDelegate getDelegate].alarmManager.arrList removeObjectAtIndex: index];
    [[AppDelegate getDelegate].alarmManager saveTimerList];
    [tblView reloadData];
    [self setupEmptyView];
}


//====================================================================================================
@end
