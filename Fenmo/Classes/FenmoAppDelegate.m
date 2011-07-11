//
//  FenmoAppDelegate.m
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FenmoAppDelegate.h"
#import "FenmoViewController.h"

@implementation FenmoAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize game;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{        
	// Override point for customization after app launch    
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
	
	game = [[FenmoGame alloc] initWithViewController:viewController];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"saved"])
		[[[[UIAlertView alloc] initWithTitle:@"恢复游戏" message:@"恢复上次未结束的游戏?" delegate:self cancelButtonTitle:@"重来" otherButtonTitles:@"恢复", nil] autorelease] show];
}

- (void)dealloc
{
	[viewController release];
	[window release];
	[super dealloc];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// stop the timers, animations and sound!
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// restart the timers, animations and sound!
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[game saveGame];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		[game restoreGame];
		[viewController startGame];
	}
}

@end
