//
//  FourthTableViewController.h
//  ExamWorld
//
//  Created by 謝 政村 on 11/11/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"

@class QuestionViewController;
@interface FourthTableViewController : SecondLevelViewController
{
    NSArray *list;
    NSString *TheYear;
    NSString *TheAbbre;
    NSString *TheClass;
    QuestionViewController *childController;
}
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSString *TheYear;
@property (nonatomic, retain) NSString *TheAbbre;
@property (nonatomic, retain) NSString *TheClass;

- (NSString *)dataFilePath;
- (void)initializeDatabase;
@end
