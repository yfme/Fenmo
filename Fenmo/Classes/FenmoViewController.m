//
//  FenmoViewController.m
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FenmoViewController.h"
#import "FenmoTimerView.h"
#import "FenmoView.h"
#import "FenmoAppDelegate.h"
#import "FenmoGame.h"

#import <AVFoundation/AVFoundation.h>

@implementation FenmoViewController

- (void)viewDidLoad
{
	CGRect	rect;
	UILabel	*tempView;
	
	[(FenmoView *)[self view] viewDidLoad];
	//声音控制
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"move" ofType:@"wav"];
	NSURL *soundURL = [[NSURL alloc] initFileURLWithPath:soundPath];
	moveSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
	moveSound.volume = 0.7;
	[soundURL release];
	
	soundPath = [[NSBundle mainBundle] pathForResource:@"score" ofType:@"caf"];
	soundURL = [[NSURL alloc] initFileURLWithPath:soundPath];
	scoreSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
	scoreSound.volume = 0.4;
	[soundURL release];
	
	// 创建并增加 timer view
	mTimerView = [[FenmoTimerView alloc] init];
	mTimerView.center = CGPointMake (160, 460);
	[[self view] addSubview:mTimerView];
	
	// 增加生命值和分数视图	
	rect = CGRectMake (0.0, 30.0, 75.0, 24.0);
	mLivesView = [[UILabel alloc] initWithFrame:rect];
	mLivesView.text = @"0";
	mLivesView.font = [UIFont boldSystemFontOfSize:26];
	mLivesView.textAlignment = UITextAlignmentCenter;
	mLivesView.textColor = [UIColor whiteColor];
	mLivesView.backgroundColor = [UIColor clearColor];
	[[self view] addSubview:mLivesView];
	rect = CGRectMake (0.0, 30.0, 75.0, 24.0);
	mLivesZoomView = [[UILabel alloc] initWithFrame:rect];
	mLivesZoomView.text = @"0";
	mLivesZoomView.font = [UIFont boldSystemFontOfSize:26];
	mLivesZoomView.textAlignment = UITextAlignmentCenter;
	mLivesZoomView.textColor = [UIColor whiteColor];
	mLivesZoomView.backgroundColor = [UIColor clearColor];
	mLivesZoomView.transform = CGAffineTransformIdentity;
	mLivesZoomView.alpha = 0.0;
	[[self view] addSubview:mLivesZoomView];
	rect = CGRectMake (245.0, 30.0, 75.0, 24.0);
	mPointsView = [[UILabel alloc] initWithFrame:rect];
	mPointsView.text = @"0";
	mPointsView.font = [UIFont boldSystemFontOfSize:26];
	mPointsView.textAlignment = UITextAlignmentCenter;
	mPointsView.textColor = [UIColor whiteColor];
	mPointsView.backgroundColor = [UIColor clearColor];
	[[self view] addSubview:mPointsView];
	rect = CGRectMake (245.0, 30.0, 75.0, 24.0);
	mPointsZoomView = [[UILabel alloc] initWithFrame:rect];
	mPointsZoomView.text = @"0";
	mPointsZoomView.font = [UIFont boldSystemFontOfSize:26];
	mPointsZoomView.textAlignment = UITextAlignmentCenter;
	mPointsZoomView.textColor = [UIColor whiteColor];
	mPointsZoomView.backgroundColor = [UIColor clearColor];
	mPointsZoomView.transform = CGAffineTransformIdentity;
	mPointsZoomView.alpha = 0.0;
	[[self view] addSubview:mPointsZoomView];
	
	//增加文本标签
	rect = CGRectMake (0.0, 60.0, 75.0, 24.0);
	tempView = [[UILabel alloc] initWithFrame:rect];
	tempView.text = @"机会";
	tempView.font = [UIFont boldSystemFontOfSize:15];
	tempView.textAlignment = UITextAlignmentCenter;
	tempView.textColor = [UIColor grayColor];
	tempView.backgroundColor = [UIColor clearColor];
	[[self view] addSubview:tempView];
	rect = CGRectMake (245.0, 60.0, 75.0, 24.0);
	tempView = [[UILabel alloc] initWithFrame:rect];
	tempView.text = @"得分";
	tempView.font = [UIFont boldSystemFontOfSize:15];
	tempView.textAlignment = UITextAlignmentCenter;
	tempView.textColor = [UIColor grayColor];
	tempView.backgroundColor = [UIColor clearColor];
	[[self view] addSubview:tempView];	
	
	//增加 tap to start 的视图
	mStartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tap-to-start.png"]];
	mStartView.center = [[self view] center];
	[[self view] addSubview:mStartView];	
	
	[[self view] retain];	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -
- (void)zoomInCenterwithColor:(int)color andShape:(int)shape
{
	NSString	*filename;
	//删除任何剩余
	[mCenterView release];
	mCenterView = nil;
	
	// 生成并放置新piece
	filename = [NSString stringWithFormat:@"piece-%d-%d-1.png", color, shape];
	mCenterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
	mCenterView.center = [[self view] center];
	[[self view] addSubview:mCenterView];
	
	//通过动画效果 进入
	mCenterView.alpha = 0.0;
	mCenterView.transform = CGAffineTransformMakeScale (0.33, 0.33);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_NORMAL];
	mCenterView.alpha = 1.0;
	mCenterView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (void)zoomOutCenter
{
	//通过动画效果 出去
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_NORMAL];
	mCenterView.alpha = 0.0;
	mCenterView.transform = CGAffineTransformMakeScale (2.0, 2.0);
	[UIView commitAnimations];
}

//暂设置为由外到内移动              
- (void)moveCenterToCircle:(int)circle
{
	[moveSound play];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_NORMAL];
	mCircleView[circle].alpha = 1.0;
	mCircleView[circle].transform = CGAffineTransformMakeScale (0.95, 0.95);
	mCircleView[circle].center = [(FenmoView *)[self view] center];
	[UIView commitAnimations];
	
	// 转移 结束
	mMovedView = mCircleView[circle];
	mCircleView[circle] = nil;
	[self performSelector:@selector(clearCircle:) withObject:[NSNumber numberWithInt:circle] afterDelay:ANIM_NORMAL];
}

- (void)clearCircle:(NSNumber *)number
{
	int	circle = [number intValue];
	
	// 淡出内外圈piece
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_NORMAL];
	mMovedView.alpha = 0.0;
	mMovedView.transform = CGAffineTransformMakeScale (0.9, 0.9);
	mCenterView.alpha = 0.0;
	mCenterView.transform = CGAffineTransformMakeScale (0.8, 0.8);
	[UIView commitAnimations];
	
	// 移除他们
	[mMovedView release];
	mMovedView = nil;
	[mCenterView release];
	mCenterView = nil;
	
	// 加入新的piece
	[[AppDelegate game] newPieceForCircle:[NSNumber numberWithInt:circle]];
}

- (void)zoomInCircle:(int)circle withColor:(int)color andShape:(int)shape
{
	NSString	*filename;
	// 删除之前的
	[mCircleView[circle] release];
	mCircleView[circle] = nil;
	
	// 产生并放置新piece
	filename = [NSString stringWithFormat:@"piece-%d-%d-0.png", color, shape];
	mCircleView[circle] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
	mCircleView[circle].center = [(FenmoView *)[self view] centerForCircle:circle];
	mCircleView[circle].alpha = 0.0;
	mCircleView[circle].transform = CGAffineTransformMakeScale (0.4, 0.4);
	[[self view] addSubview:mCircleView[circle]];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_NORMAL];
	mMovedView.alpha = 0.0;
	mMovedView.transform = CGAffineTransformMakeScale (0.33, 0.33);
	mCircleView[circle].alpha = 1.0;
	mCircleView[circle].transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (void)updateTimer:(int)timervalue
{
	[mTimerView setPosition:timervalue];
}

- (void)updateLives:(int)lives
{
	// 更新显示
	mLivesView.text = [NSString stringWithFormat:@"%d", lives];
	mLivesZoomView.text = [NSString stringWithFormat:@"%d", lives];
	
	mLivesZoomView.transform = CGAffineTransformIdentity;
	mLivesZoomView.alpha = 1.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_SHORT];
	mLivesZoomView.transform = CGAffineTransformMakeScale (9.5, 9.5);//新生命值的淡出大小
	mLivesZoomView.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)updateScore:(int)points
{
	[scoreSound play];
	
	mPointsView.text = [NSString stringWithFormat:@"%d", points];
	mPointsZoomView.text = [NSString stringWithFormat:@"%d", points];
	[moveSound play];
	
	mPointsZoomView.transform = CGAffineTransformIdentity;
	mPointsZoomView.alpha = 1.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_SHORT];
	mPointsZoomView.transform = CGAffineTransformMakeScale (4.5, 4.5);
	mPointsZoomView.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)startGame
{
	// 淡出移去mStartView
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_SHORT];
	mStartView.alpha = 0.0;
	mStartView.transform = CGAffineTransformMakeScale (6.0, 6.0);
	[UIView commitAnimations];
}

- (void)gameOver
{
	UIImageView	*imageView;
	// 创建GameOver视图
	imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game-over.png"]];
	imageView.center = [self view].center;
	imageView.alpha = 0.0;
	imageView.transform = CGAffineTransformMakeScale (6.0, 6.0);
	[[self view] addSubview:imageView];
	
	// 淡入
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:ANIM_LONG];
	imageView.alpha = 1.0;
	imageView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:7];
	imageView.alpha = 0.0;
	imageView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
	
	[imageView release];
	imageView=nil;
}

- (void)dealloc
{
    [mStartView release];
	[mCenterView release];
	[mMovedView release];
	[mCircleView[GAME_CIRCLES] release];
	[mTimerView release];
	[mLivesView release];
	[mLivesZoomView release];
	[mPointsView release];
	[mPointsZoomView release];
	[moveSound release];
	[scoreSound release];
	[super dealloc];		
}

@end