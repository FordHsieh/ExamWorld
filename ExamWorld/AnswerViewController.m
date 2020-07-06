//
//  AnswerViewController.m
//  ExamWorld
//
//  Created by 謝 政村 on 11/12/13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AnswerViewController.h"

@implementation AnswerViewController
@synthesize AnsPDFLocation;
@synthesize pdfWebView;

- (IBAction)GoBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
    NSURL *url = [[NSURL alloc]initWithString:AnsPDFLocation];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:@"Answer.pdf"];
    
    // 這邊先殺掉檔案
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:pdfPath error:NULL];
    
    //在讀取檔案
    [data writeToFile:pdfPath atomically:YES];
    
    NSURL *url1 = [NSURL fileURLWithPath: pdfPath];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
    [[self pdfWebView] loadRequest:request1];
    
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

@end
