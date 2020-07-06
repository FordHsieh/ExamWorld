//
//  SecondTableViewController.m
//  ExamWorld
//
//  Created by 謝 政村 on 11/11/19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SecondTableViewController.h"
#import "ThirdTableViewController.h"
#import <sqlite3.h>

@implementation SecondTableViewController
@synthesize list;
@synthesize TheYear;

//#define kFileName   @"99_ExamWorld.sqlite"

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *kFileName = [[NSString alloc]initWithFormat:@"%@_ExamWorld.sqlite",self.TheYear];
    return [documentsDirectory stringByAppendingPathComponent:kFileName];
}

// 檢查資料庫是否存在並復制到 Documents
- (void)initializeDatabase
{
    NSString *databasePath = [self dataFilePath];
    
    //檢查資料庫是否已經存在 Document 路徑內
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:databasePath];
    //若已經存在則不用從應用程式的資源檔內拷貝到 Documents
    if (success)
    {
        return;
    }
    
    //否則從應用程式複製到 Documents 目錄
    NSString *ExamName = [[NSString alloc]initWithFormat:@"%@_ExamWorld", self.TheYear];
    NSString *resourcePath = [[NSBundle mainBundle]pathForResource:ExamName ofType:@"sqlite"];
    [fileManager copyItemAtPath:resourcePath toPath:databasePath error:nil];
}

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
    NSMutableArray *Abbre = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    ///////////////////////////////////////////////////////////////////////////////////////
    // 開啟資料庫 以及將資料庫存入陣列
    // 開啟 sqlite
    NSString *dataPath = [self dataFilePath];
    [self initializeDatabase];
    //NSLog(@"#############\n");
    //NSLog(@"%@", dataPath);
    //NSLog(@"@@@@@@@@@@@@@\n");

    sqlite3 *database;
    if(sqlite3_open([dataPath UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    else
    {
        NSString *sql = @"SELECT DISTINCT EXAM_ABBRE FROM ExamInfo1";
        sqlite3_stmt *stm;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stm, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stm) == SQLITE_ROW)
            {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 0)];
                // NSLog(@"%@",name);
                [Abbre addObject:name];
            }
            sqlite3_finalize(stm);
        }
    }
    sqlite3_close(database);
    /////////////////////////////////////////////////////////////////////////////////////////
    
    // Third Table Set
    for(int i=0;i<Abbre.count;i++)
    {
        ThirdTableViewController *thirdTableViewController = [[ThirdTableViewController alloc]initWithStyle:UITableViewStylePlain];
        thirdTableViewController.title = [[NSString alloc]initWithFormat:@"%@",[Abbre objectAtIndex:i]];
        thirdTableViewController.TheYear = self.TheYear;
        thirdTableViewController.TheAbbre = [[NSString alloc]initWithFormat:@"%@",[Abbre objectAtIndex:i]];
        // NSLog(@"%@", thirdTableViewController.title);
        [array addObject:thirdTableViewController];
    }
    self.list = array;
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.list = nil;
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
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    ThirdTableViewController *controller = [list objectAtIndex:row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    }
    cell.textLabel.text = controller.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSUInteger row = [indexPath row];
    SecondLevelViewController *nextController = [self.list objectAtIndex:row];
    [self.navigationController pushViewController:nextController animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSUInteger row = [indexPath row];
    ThirdTableViewController *controller = [list objectAtIndex:row];
    
    NSString *cellText = controller.title;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:20.0];
    
    CGSize constrainSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //define ipad
        constrainSize = CGSizeMake(680.0f, MAXFLOAT);
    else                                                      // define iphone
        constrainSize = CGSizeMake(400.0f, MAXFLOAT);
    
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constrainSize];
    
    return labelSize.height+20;
}

@end
