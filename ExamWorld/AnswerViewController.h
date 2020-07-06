//
//  AnswerViewController.h
//  ExamWorld
//
//  Created by 謝 政村 on 11/12/13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerViewController : UIViewController
{
    NSString *AnsPDFLocation;
    UIWebView *pdfWebView;
}
@property (nonatomic, retain) NSString *AnsPDFLocation;
@property (nonatomic, retain) IBOutlet UIWebView *pdfWebView;

- (IBAction)GoBack:(id)sender;
@end
