//
//  QuestionViewController.m
//  ExamWorld
//
//  Created by 謝 政村 on 11/12/4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "QuestionViewController.h"
#import "AnswerViewController.h"
#import <sqlite3.h>

@implementation QuestionViewController
@synthesize pdfWebView;
@synthesize Year;
@synthesize Abbre;
@synthesize Class;
@synthesize Subject;
@synthesize QuePDFLocation;
@synthesize AnsPDFLocation;
@synthesize ReAnsPDFLocation;
@synthesize alert;
//@synthesize bannerView_;

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *kFileName = [[NSString alloc]initWithFormat:@"%@_ExamWorld.sqlite",self.Year];
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
    NSString *ExamName = [[NSString alloc]initWithFormat:@"%@_ExamWorld", self.Year];
    NSString *resourcePath = [[NSBundle mainBundle]pathForResource:ExamName ofType:@"sqlite"];
    [fileManager copyItemAtPath:resourcePath toPath:databasePath error:nil];
}

-(IBAction)AnsButPressed
{
    // do something here
    NSLog(@"我跑進來AnsWerPressed\n");
    ///////////////////
    AnswerViewController *AnswerController = [[AnswerViewController alloc]initWithNibName:nil bundle:nil];
    AnswerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    if (self.AnsPDFLocation!=nil)
        AnswerController.AnsPDFLocation = self.AnsPDFLocation;
    else
        AnswerController.AnsPDFLocation = self.ReAnsPDFLocation;
    [self presentModalViewController:AnswerController animated:YES];
    NeedUpdate=1;
    ///////////////////
}

- (void)ShowAlertView
{
    ////////////////////////////////////////////////////////////////////
    //@ 顯示載入檔案
    alert = [[UIAlertView alloc]initWithTitle:@"載入檔案\n請耐心稍候 ..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(alert.bounds.size.width/2,alert.bounds.size.height/2+10);
    [indicator startAnimating];
    [alert addSubview:indicator];
    //[indicator relase];
    /////////////////////////////////////////////////////////////////////
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
- (void)viewDidAppear:(BOOL)animated
{
    if (NeedUpdate == 0)
    {
        [super viewDidAppear:animated];
        
        self.navigationItem.rightBarButtonItem = nil;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //dispatch_async(dispatch_get_main_queue(), ^{
        //    [self ShowAlertView];
        //});
        
        NSMutableArray *Question = [[NSMutableArray alloc] init];
        NSMutableArray *Answer   = [[NSMutableArray alloc] init];
        NSMutableArray *ReAnswer = [[NSMutableArray alloc] init];
        //NSString *Question, *Answer, *ReAnswer;
        NSInteger HaveAnswer=0;
        NSInteger HaveReAnswer=0;
    
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
            //@ 取得考題Question
            NSString *sql1 = [[NSString alloc]initWithFormat:@"SELECT DISTINCT EXAM_QUESTION, EXAM_ANSWER, EXAM_REANSWER FROM ExamInfo1 WHERE (EXAM_ABBRE LIKE '%%%@%%' AND EXAM_CLASS LIKE '%%%@%%' AND EXAM_SUBJECT LIKE '%%%@%%')", self.Abbre, self.Class, self.Subject];
            NSLog(@"%@", sql1);
            sqlite3_stmt *stm1;
            if(sqlite3_prepare_v2(database, [sql1 UTF8String], -1, &stm1, nil) == SQLITE_OK)
            {
                while(sqlite3_step(stm1) == SQLITE_ROW)
                {     
                    NSString *question;
                    NSString *answer;
                    NSString *reanswer;
                    
                    question = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stm1, 0)];
                    [Question addObject:question];
                    
                    if (sqlite3_column_text(stm1, 1)!=nil)
                    {
                        answer=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stm1, 1)];
                        if ([answer length] != 0)
                        {
                            HaveAnswer=1;
                            [Answer addObject:answer];
                            NSLog(@"answer %@", answer);
                        }
                    }
                    
                    if (sqlite3_column_text(stm1, 2)!=nil)
                    {
                        reanswer=[NSString stringWithUTF8String:(char *)sqlite3_column_text(stm1, 2)];
                        if ([reanswer length] != 0)
                        {
                            HaveReAnswer=1;
                            [ReAnswer addObject:reanswer];
                            NSLog(@"reanswer %@", reanswer);
                        }
                    }
                    
                    //NSLog(@"%@\n",question);
                    //NSLog(@"%@\n",answer);
                    //NSLog(@"%@\n",reanswer);
                }
                sqlite3_finalize(stm1);
            }
    
            
        }
        sqlite3_close(database);
        /////////////////////////////////////////////////////////////////////////////////////////
            
            if (HaveAnswer==1)
            {
                self.AnsPDFLocation = [Answer objectAtIndex:0];
                NSRange search = [self.AnsPDFLocation rangeOfString:@".pdf"];
                NSLog(@"HaveAnswer = %i", search.location);
                if (search.location != 0) 
                    HaveAnswer=1;
                else 
                    HaveAnswer=0;
            }
            if (HaveReAnswer==1)
            {
                self.ReAnsPDFLocation = [ReAnswer objectAtIndex:0];
                NSRange search = [self.ReAnsPDFLocation rangeOfString:@".pdf"];
                NSLog(@"HaveReAnswer = %i", search.location);
                if(search.location != 0)
                    HaveReAnswer=1;
                else
                    HaveReAnswer=0;
            }
            // 設定導覽右上按鈕
            NSLog(@"**%d***\n", HaveAnswer);
            NSLog(@"**%d***\n", HaveReAnswer);
            if ((HaveAnswer==1) || (HaveReAnswer==1))
            {
                UIBarButtonItem *AnsButton = [[UIBarButtonItem alloc]initWithTitle:@"答案" style:UIBarButtonItemStyleBordered target:self action:@selector(AnsButPressed)];
                self.navigationItem.rightBarButtonItem = AnsButton;
            }
            else
                self.navigationItem.rightBarButtonItem = nil;
        
            // 設定 QuesPDFLocation, AnsPDFLocation, ReAnsPDFLocation
            self.QuePDFLocation = [Question objectAtIndex:0];
            
            //PDFScrollView *sv = [[PDFScrollView alloc] initWithFrame:[[self view] bounds]];
            NSURL *url = [[NSURL alloc]initWithString:QuePDFLocation];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:@"Question.pdf"];
            
            // 這邊先殺掉檔案
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:pdfPath error:NULL];
            
            //再寫檔案
            [data writeToFile:pdfPath atomically:YES];
            
            // disable show alert
            //[self.alert dismissWithClickedButtonIndex:0 animated:YES];
            
            NSURL *url1 = [NSURL fileURLWithPath:pdfPath];
            NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
            [[self pdfWebView] loadRequest:request1];

        // disable show alert
        //[self.alert dismissWithClickedButtonIndex:0 animated:YES];
    }); // end GCD
    
#if 1
        //////////////////////////////////////////////////////////////////////////////////
        // Create a view of the standard size at the bottom of the screen.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //define ipad
            bannerView_ = [[GADBannerView alloc]
                            initWithFrame:CGRectMake(0.0,
                            self.view.frame.size.height -
                            GAD_SIZE_468x60.height,
                            GAD_SIZE_468x60.width,
                            GAD_SIZE_468x60.height)];
        else                                                      // define iphone
            bannerView_ = [[GADBannerView alloc]
                            initWithFrame:CGRectMake(0.0,
                            self.view.frame.size.height -
                            GAD_SIZE_320x50.height,
                            GAD_SIZE_320x50.width,
                            GAD_SIZE_320x50.height)];
    
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = @"a14ee8520eae44c";
    
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
    
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
        //////////////////////////////////////////////////////////////////////////////////
#endif
    }
    //結束載入訊息
    NeedUpdate=0;
}

- (void)viewDidUnload
{    
    [self setPdfWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.pdfWebView = nil;
    self.Year = nil;
    self.Abbre = nil;
    self.Class = nil;
    self.Subject = nil;
    
    self.QuePDFLocation = nil;
    self.AnsPDFLocation = nil;
    self.ReAnsPDFLocation = nil;
    self.alert = nil;
    //self.bannerView_=nil;
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

/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
        fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        
    }
}
 */

@end
