//
//  FenmoGame.h
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GAME_CIRCLES	6 //外圈的个数	
#define GAME_TIMERSTEPS	12//计时点数

#define GAME_COLOR		0
#define GAME_SHAPE		1

#define GAME_MAXCOLORS	3
#define GAME_MAXSHAPES	3

#define GAME_INIT		0
#define GAME_RUNNING	1
#define GAME_OVER		2

@class FenmoViewController; //引用类FenmoViewController

//定义接口 NSObject的子类FenmoGame
@interface FenmoGame : NSObject {
	
	FenmoViewController *mController;

	int mCenter[2];					// 中间棋子的颜色和形状
	int mCircle[GAME_CIRCLES][2];	// 外圈的颜色和形状
	int mTime;						// the state of the running-out timer
	int mLives;						// 剩余生命或机会数
	int mPoints;					// 匹配得分
	BOOL mState;					// 游戏的状态 (running, over, etc.)
	BOOL mBlocked;					// 是否暂停用于播放动画
}

- (id)initWithViewController:(FenmoViewController *)controller; //初始化控制器

- (void)startGame;	//开始游戏

- (BOOL)moveCenterToCircle:(int)circle;			//从中间移到周围
- (void)newPieceForCircle:(NSNumber *)circle;	//外围增加新圈

- (void)saveGame;								//保存游戏
- (void)restoreGame;							//

@end

