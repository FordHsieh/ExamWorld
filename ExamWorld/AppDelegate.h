//
//  AppDelegate.h
//  ExamWorld
//
//  Created by 謝 政村 on 11/11/19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FirstTableViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    FirstTableViewController *firstTableViewController;
    UINavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) FirstTableViewController *firstTableViewController;
@property (nonatomic, retain) UINavigationController *navigationController;
@end
