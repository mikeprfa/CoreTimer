//
//  EditViewController.m
//  CTimer
//
//  Created by jian on 5/6/15.
//  Copyright (c) 2015 Matei. All rights reserved.
//

#import "EditViewController.h"
#import "EditTimerTableViewCell.h"

@interface EditViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, EditTimerTableViewCellDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITableView    *tblView;

@end

@implementation EditViewController
@synthesize tblView;

//====================================================================================================
- (void)viewDidLoad
{
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
    [tblView registerNib:[UINib nibWithNibName:@"EditTimerTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditTimerTableViewCell"];
}

//====================================================================================================
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [tblView reloadData];
}

//====================================================================================================
- (IBAction)actionDone:(id)sender
{
    [self actionBack: nil];
}

//====================================================================================================
- (IBAction)actionAddTimer:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id nextView = [storyboard instantiateViewControllerWithIdentifier: @"AddTimerViewController"];
    [self.navigationController pushViewController: nextView animated: YES];
}

#pragma mark - UITextField Delegate.

//====================================================================================================
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    [cell updateTimer: [[AppDelegate getDelegate].alarmManager.arrList objectAtIndex: indexPath.row] view: VIEW_EDIT];
    
    return cell;
}

//====================================================================================================
- (void) trashTimer:(int)index
{
    [[AppDelegate getDelegate].alarmManager.arrList removeObjectAtIndex: index];
    [[AppDelegate getDelegate].alarmManager saveTimerList];
    [tblView reloadData];
}

//====================================================================================================
@end
