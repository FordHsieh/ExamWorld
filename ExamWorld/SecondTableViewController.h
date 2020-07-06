//
//  SecondTableViewController.h
//  ExamWorld
//
//  Created by 謝 政村 on 11/11/19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"

@interface SecondTableViewController : SecondLevelViewController
{
    NSArray *list;
    NSString *TheYear;
}
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSString *TheYear;

- (NSString *)dataFilePath;
- (void)initializeDatabase;
@end
