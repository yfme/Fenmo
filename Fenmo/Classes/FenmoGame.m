//
//  FenmoGame.m
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FenmoGame.h"
#import "FenmoViewController.h"

@interface FenmoGame (Private)

- (void)startTimer;
- (float)timerInterval;
- (void)timerAdvanced:(NSTimer *)timer;
- (void)newCenterPiece;
- (void)zoomInCircle:(NSNumber *)number;

@end

@implementation FenmoGame (Private)

- (void)startTimer
{
	[NSTimer scheduledTimerWithTimeInterval:[self timerInterval] target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
}

- (float)timerInterval
{
	// 得分越高速度越快
	return (60.0 / ((float)mPoints + 150.0));
}

- (void)timerAdvanced:(NSTimer *)timer
{
	// 阻塞暂停时不推进时间
	if (mBlocked)
		return;
	
	// 新棋子，重新计时
	if (mTime == 0)
	{
		[timer invalidate];
		[self startTimer];
	}
	
	// 增加时间
	[mController updateTimer:mTime];
	mTime++;
	if (mTime >= GAME_TIMERSTEPS)
	{
		// 生命减一
		mLives--;
		[mController updateLives:mLives];
		if (mLives <= 0)
		{
			// 游戏结束
			mState = GAME_OVER;
			[timer invalidate];
			[mController gameOver];
		}
		else
		{
			// 新棋子
			[self newCenterPiece];
			mTime = 0;
		}
	}
}

- (void)newCenterPiece
{
	// 淡走之前的piece
	[mController zoomOutCenter];
	
	// 随机寻找一个新piece
	mCenter[GAME_COLOR] = rand () % GAME_MAXCOLORS;
	mCenter[GAME_SHAPE] = mCircle[rand () % GAME_CIRCLES][GAME_SHAPE];
	
	// 显示它
	[mController zoomInCenterwithColor:mCenter[GAME_COLOR] andShape:mCenter[GAME_SHAPE]];
	
	// 重置计时器
	mTime = 0;
	[mController updateTimer:mTime];
}

- (void)zoomInCircle:(NSNumber *)number
{
	int	circle = [number intValue];
	
	[mController zoomInCircle:circle withColor:mCircle[circle][GAME_COLOR] andShape:mCircle[circle][GAME_SHAPE]];
}

@end


@implementation FenmoGame

- (id)initWithViewController:(FenmoViewController *)controller
{
	//高级初始化
	self = [super init];
	if (!self)
		return nil;
	
	//一般初始化
	mController = [controller retain];
	mLives = 3;
	mTime = 0;
	mPoints = 0;
	mState = GAME_INIT;
	mBlocked = NO;
	mCenter[GAME_COLOR] = mCenter[GAME_SHAPE] = 0;
	for (int i = 0; i < GAME_CIRCLES; i++)
		mCircle[i][GAME_COLOR] = mCircle[i][GAME_SHAPE] = 0;
	
	return self;
}

- (void) dealloc
{
	// 清除
	[mController release];
	[super dealloc];
}

- (void)startGame
{
	if (mState == GAME_RUNNING)
		return;
	mState = GAME_RUNNING;
	mLives = 3;	
	[mController startGame];//调用viewcontroller中的startGame
	
	// 填充外圈
	for (int i = 0; i < GAME_CIRCLES; i++)
		[self performSelector:@selector(newPieceForCircle:) withObject:[NSNumber numberWithInteger:i] afterDelay:((float)i*0.2)];
	
	// 填充内圈
	[self performSelector:@selector(newCenterPiece) withObject:nil afterDelay:1.4];
	
	// 开始游戏
	[self performSelector:@selector(startTimer) withObject:nil afterDelay:1.6];
	[mController updateLives:mLives];
}

//是否执行移动
- (BOOL)moveCenterToCircle:(int)circle
{
	// 当阻塞或游戏结束时不执行动画
	if (mBlocked || (mState == GAME_OVER))
		return NO;
	
	if (mCenter[GAME_SHAPE] == mCircle[circle][GAME_SHAPE])
	{
		// 判断是否有相同的颜色
		if (mCenter[GAME_COLOR] == mCircle[circle][GAME_COLOR])
		{
			mPoints++;
			[mController updateScore:mPoints];
		}
		// 开始移动并创建新的中心棋子
		[mController moveCenterToCircle:circle];
		mCenter[GAME_COLOR] = mCenter[GAME_SHAPE] = 0;
		[self performSelector:@selector(newCenterPiece) withObject:nil afterDelay:0.4];
		//[self newCenterPiece];
		mBlocked = YES;
		return YES;
	}
	else
		// 不能放置
		return NO;
}

- (void)newPieceForCircle:(NSNumber *)circle
{
	int		num = [circle intValue];
	BOOL	centerFound = NO;
	
	// 寻找新的圆圈，并确保可以和中间的匹配
	for (int i = 0; i < GAME_CIRCLES; i++)
		if ((mCenter[GAME_SHAPE] == mCircle[i][GAME_SHAPE]) && (i != num) )
			centerFound = YES;
	mCircle[num][GAME_COLOR] = rand () % GAME_MAXCOLORS;
	if (centerFound)
		mCircle[num][GAME_SHAPE] = rand () % GAME_MAXSHAPES;
	else
		mCircle[num][GAME_SHAPE] = mCenter[GAME_SHAPE];
	
	// 显示
	[mController zoomInCircle:num withColor:mCircle[num][GAME_COLOR] andShape:mCircle[num][GAME_SHAPE]];
	mBlocked = NO;
}

- (void)saveGame
{
	NSUserDefaults	*prefs = nil;
	
	prefs = [NSUserDefaults standardUserDefaults];
	if (mState == GAME_RUNNING)
	{	
		[prefs setObject:[NSNumber numberWithBool:YES] forKey:@"saved"];
		[prefs setObject:[NSData dataWithBytes:mCircle length:sizeof(mCircle)] forKey:@"circle"];
		[prefs setObject:[NSNumber numberWithInt:mLives] forKey:@"lives"];
		[prefs setObject:[NSNumber numberWithInt:mPoints] forKey:@"points"];
	}
	else
		[prefs setObject:[NSNumber numberWithBool:NO] forKey:@"saved"];
}

//储存上次未结束的游戏
- (void)restoreGame
{
	NSUserDefaults	*prefs = nil;
	
	prefs = [NSUserDefaults standardUserDefaults];
	
	[[prefs dataForKey:@"center"] getBytes:mCenter length:sizeof(mCenter)];
	[[prefs dataForKey:@"circle"] getBytes:mCircle length:sizeof(mCircle)];
	mTime = 0;
	mLives = [prefs integerForKey:@"lives"];
	mPoints = [prefs integerForKey:@"points"];
	mState = GAME_RUNNING;
	
	// 填充外圈
	for (int i = 0; i < GAME_CIRCLES; i++)
		[self performSelector:@selector(zoomInCircle:) withObject:[NSNumber numberWithInteger:i] afterDelay:((float)i*0.2)];
	
	// 新内圈
	[self performSelector:@selector(newCenterPiece) withObject:nil afterDelay:1.4];
	
	// 开始游戏
	[self performSelector:@selector(startTimer) withObject:nil afterDelay:1.6];
	[mController updateLives:mLives];
	[mController updateScore:mPoints];
}

@end
