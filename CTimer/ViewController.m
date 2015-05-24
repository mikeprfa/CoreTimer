//
//  ViewController.m
//  CTimer
//
//  Created by jian on 5/2/15.
//  Copyright (c) 2015 Matei. All rights reserved.
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    
    btnStart.layer.masksToBounds = YES;
    btnStart.layer.cornerRadius = btnStart.frame.size.height / 2.0f;
    
    [tblView registerNib:[UINib nibWithNibName:@"EditTimerTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditTimerTableViewCell"];
}

//====================================================================================================
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
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
    if(bExistTimer)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        id nextView = [storyboard instantiateViewControllerWithIdentifier: @"EditViewController"];
        [self.navigationController pushViewController: nextView animated: YES];
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

//====================================================================================================
@end
