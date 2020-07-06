//
//  FirstTableViewController.m
//  ExamWorld
//
//  Created by 謝 政村 on 11/11/19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FirstTableViewController.h"
#import "SecondLevelViewController.h"
#import "SecondTableViewController.h"

@implementation FirstTableViewController
@synthesize controllers;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"公職考題";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    // Table Set
    for(int i=101;i>82;i--)
    {
        SecondTableViewController *secondTableViewController = [[SecondTableViewController alloc]initWithStyle:UITableViewStylePlain];
        NSString *Name = [NSString stringWithFormat:@"民國 %d 年考題", i];
        secondTableViewController.title = Name;
        secondTableViewController.TheYear = [[NSString alloc]initWithFormat:@"%d", i]; 
        [array addObject:secondTableViewController];
    }
    
    self.controllers = array;
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.controllers = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //define ipad
        return ((interfaceOrientation==UIInterfaceOrientationPortrait)||
                (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown));
    else                                                      // define iphone
        return ((interfaceOrientation==UIInterfaceOrientationLandscapeRight)||
                (interfaceOrientation==UIInterfaceOrientationLandscapeLeft));
    //return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.controllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 0
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSUInteger row = [indexPath row];
    SecondLevelViewController *controller = [controllers objectAtIndex:row];
    cell.textLabel.text = controller.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    
    return cell;
#else
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    SecondTableViewController *controller = [controllers objectAtIndex:row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    }
    cell.textLabel.text = controller.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
#endif
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSUInteger row = [indexPath row];    
    SecondTableViewController *nextController = [self.controllers objectAtIndex:row];
    [self.navigationController pushViewController:nextController animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSUInteger row = [indexPath row];
    SecondTableViewController *controller = [controllers objectAtIndex:row];
    
    NSString *cellText = controller.title;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:20.0];
    CGSize constrainSize = CGSizeMake(400.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constrainSize];
    
    return labelSize.height+20;
}
@end
