//
//  FenmoAppDelegate.h
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FenmoViewController;
@class FenmoGame;

#define AppDelegate	(FenmoAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface FenmoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FenmoViewController *viewController;
	FenmoGame *game;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FenmoViewController *viewController;
@property (readonly) FenmoGame *game;

@end

