//
//  FenmoView.m
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FenmoView.h"
#import	"FenmoAppDelegate.h"

CGRect CGRectMakeWithCenter (CGPoint center, CGFloat diameter)
{
	return CGRectMake (center.x - diameter / 2, center.y - diameter / 2, diameter, diameter);
}

CGPoint CGPointMakeFromRect (CGRect rect)
{
	return CGPointMake (rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

@implementation FenmoView

- (void)dealloc
{
	// 清除
	CGGradientRelease (mGradient);
	[super dealloc];
}

- (void)viewDidLoad
{
	CGPoint		center, point;
	CGFloat		degree = 0;
	
	// 初始化rectangles
	center = self.center;
	mCenterRect = CGRectMakeWithCenter (center, RADIUS - 4);
	for (int i = 0; i < GAME_CIRCLES; i++)
	{
		point.x = center.x - sin (degree) * RADIUS;
		point.y = center.y + cos (degree) * RADIUS;
		mPieRect[i] = CGRectMakeWithCenter (point, RADIUS - 4);
		degree += PI / 3.0;
	}
	
	// 初始化渐变梯度
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB ();
	CGFloat colors[] =
	{
		16.0 / 255.0, 32.0 / 265.0, 32.0 / 255.0, 1.0,
		64.0 / 255.0, 64.0 / 255.0, 100.0 / 255.0, 1.0
	};
	mGradient = CGGradientCreateWithColorComponents (rgb, colors, NULL, 2);
	CGColorSpaceRelease (rgb);
	
}

- (CGPoint)centerForCircle:(int)circle
{
	return CGPointMakeFromRect (mPieRect[circle]);
}

- (CGPoint)circleForCenter:(int)center{
	return CGPointMakeFromRect(mCenterRect);
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef	context;
	CGPoint			start, end;
	
	// 绘制渐变背景
	context = UIGraphicsGetCurrentContext ();
	start = [self frame].origin;
	end = start;
	end.y += [self frame].size.height;
	CGContextDrawLinearGradient (context, mGradient, start, end, 0);
	
	// 画中间的圈
	CGContextFillEllipseInRect (context, mCenterRect);
	
	// 画外围的圈
	for (int i = 0; i < GAME_CIRCLES; i++)
		CGContextFillEllipseInRect (context, mPieRect[i]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint		touched;
	
	//寻找触摸的位置
	touched = [[touches anyObject] locationInView:self];
	
	//中心位置测到触摸
	if (CGRectContainsPoint (mCenterRect, touched))
		[[AppDelegate game] startGame];
	
	//外围测到触摸
	for (int i = 0; i < GAME_CIRCLES; i++)
		if (CGRectContainsPoint (mPieRect[i], touched))
			[[AppDelegate game] moveCenterToCircle:i];
}

@end
