//
//  ThirdTableViewController.h
//  ExamWorld
//
//  Created by 謝 政村 on 11/11/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"

@interface ThirdTableViewController : SecondLevelViewController
{
    NSArray *list;
    NSString *TheYear;
    NSString *TheAbbre;
}
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSString *TheYear;
@property (nonatomic, retain) NSString *TheAbbre;

- (NSString *)dataFilePath;
- (void)initializeDatabase;
@end
