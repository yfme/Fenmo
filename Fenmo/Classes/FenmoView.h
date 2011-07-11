//
//  FenmoView.h
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenmoGame.h"

#define RADIUS		116.0 //中间和外围圆圈的半径
#define PI			3.141592653589793//圆周率


//FenmoView为UIView的子类
@interface FenmoView : UIView
{
	CGRect			mPieRect[GAME_CIRCLES];//周围的区域
	CGRect			mCenterRect;			//中心区域
	CGGradientRef	mGradient;				//渐变
}

- (void)viewDidLoad;

- (CGPoint)centerForCircle:(int)circle;

@end
