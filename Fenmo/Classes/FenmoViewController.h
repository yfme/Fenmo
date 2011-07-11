//
//  FenmoViewController.h
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FenmoGame.h"

#define ANIM_SHORT		0.3
#define ANIM_NORMAL		0.4
#define ANIM_LONG		1.2

@class FenmoTimerView;

@interface FenmoViewController : UIViewController
{
	UIImageView		*mStartView;
	UIImageView		*mCenterView;
	UIImageView		*mMovedView;
	UIImageView		*mCircleView[GAME_CIRCLES];
	FenmoTimerView	*mTimerView;
	UILabel			*mLivesView;
	UILabel			*mLivesZoomView;
	UILabel			*mPointsView;
	UILabel			*mPointsZoomView;
	
	AVAudioPlayer *moveSound;
	AVAudioPlayer *scoreSound;
}

- (void)zoomInCenterwithColor:(int)color andShape:(int)shape;
- (void)zoomOutCenter;

- (void)moveCenterToCircle:(int)circle;
- (void)zoomInCircle:(int)circle withColor:(int)color andShape:(int)shape;

- (void)updateTimer:(int)timervalue;
- (void)updateLives:(int)lives;
- (void)updateScore:(int)points;

- (void)startGame;
- (void)gameOver;

@end
