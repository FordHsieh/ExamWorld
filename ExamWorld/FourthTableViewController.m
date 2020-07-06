//
//  FourthTableViewController.m
//  ExamWorld
//
//  Created by 謝 政村 on 11/11/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FourthTableViewController.h"
#import "QuestionViewController.h"
#import <sqlite3.h>

@implementation FourthTableViewController
@synthesize list;
@synthesize TheYear;
@synthesize TheAbbre;
@synthesize TheClass;

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
    NSMutableArray *Subject = [[NSMutableArray alloc] init];
#if 1    
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
        NSString *sql = [[NSString alloc]initWithFormat:@"SELECT DISTINCT EXAM_SUBJECT FROM ExamInfo1 WHERE (EXAM_ABBRE LIKE '%%%@%%' AND EXAM_CLASS LIKE '%%%@%%')", self.TheAbbre, self.TheClass];
        //NSLog(@"%@", sql);
        sqlite3_stmt *stm;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &stm, nil) == SQLITE_OK)
        {
            while(sqlite3_step(stm) == SQLITE_ROW)
            {
                NSString *subject = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm, 0)];
                // NSLog(@"%@",name);
                [Subject addObject:subject];
            }
            sqlite3_finalize(stm);
        }
    }
    sqlite3_close(database);
    /////////////////////////////////////////////////////////////////////////////////////////
#endif   
    self.list = Subject;
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.list = nil;
    self.TheYear = nil;
    self.TheAbbre = nil;
    self.TheClass = nil;
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [list count];
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
    NSString *rowString = [list objectAtIndex:row];
    cell.textLabel.text = rowString;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
#else
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSString *rowString = [list objectAtIndex:row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    }
    cell.textLabel.text = rowString;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
#endif
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (childController == nil)
    {
        childController = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    }
    NSUInteger row = [indexPath row];
    NSString *SubjectItem = [list objectAtIndex:row];
    NSString *detailMessage = [[NSString alloc]initWithFormat:@"%@", SubjectItem];
    childController.title = detailMessage;
    
    //childController.PDFLocation = [Question objectAtIndex:0];
    //childController.AnsPDFLocation = [Answer objectAtIndex:0];
    //childController.ReAnsPDFLocation = [ReAnswer objectAtIndex:0];
    childController.Year = self.TheYear;
    childController.Abbre = self.TheAbbre;
    childController.Class = self.TheClass;
    childController.Subject = SubjectItem;
    [self.navigationController pushViewController:childController animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSString *SubjectItem = [list objectAtIndex:row];
    
    NSString *cellText = SubjectItem;
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
