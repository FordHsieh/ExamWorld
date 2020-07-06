//
//  QuestionViewController.h
//  ExamWorld
//
//  Created by 謝 政村 on 11/12/4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
// Import GADBannerView’s definition from the SDK
#import "GADBannerView.h"

@interface QuestionViewController : UIViewController
{
    UIWebView *pdfWebView;
    // Year, Abbre, Class, subject
    NSString *Year;
    NSString *Abbre;
    NSString *Class;
    NSString *Subject;
    
    // PDF 網址
    NSString *QuePDFLocation;
    NSString *AnsPDFLocation;
    NSString *ReAnsPDFLocation;
    
    // Alert View
    UIAlertView *alert;
    //NSInteger *IsShowAlert;
    
    // 檢查是否需要更新
    NSInteger NeedUpdate;
    
    // Declare one as an instance variable
    GADBannerView *bannerView_;
}
@property (nonatomic, retain) IBOutlet UIWebView *pdfWebView;
@property (nonatomic, retain) NSString *Year;
@property (nonatomic, retain) NSString *Abbre;
@property (nonatomic, retain) NSString *Class;
@property (nonatomic, retain) NSString *Subject;

@property (nonatomic, retain) NSString *QuePDFLocation;
@property (nonatomic, retain) NSString *AnsPDFLocation;
@property (nonatomic, retain) NSString *ReAnsPDFLocation;
//@property (nonatomic, retain) GADBannerView *bannerView_;
@property (nonatomic, retain) UIAlertView *alert;

- (NSString *)dataFilePath;
- (void)initializeDatabase;
- (IBAction)AnsButPressed;
- (void) ShowAlertView;
@end
