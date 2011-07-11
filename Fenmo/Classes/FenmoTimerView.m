//
//  FenmoTimerView.m
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FenmoTimerView.h"

@implementation FenmoTimerView

- (id)init
{
	int	i;
	
	// 储存图片
	for (i = 0; i < GAME_TIMERSTEPS; i++)
		mProgressImage[i] = [[UIImage imageNamed:[NSString stringWithFormat:@"progress-%d.png", (i+1)]] retain];
	// super初始化
	self = [super initWithImage:mProgressImage[0]];
	if (!self)
		return nil;
	// 其他初始化
	mPosition = 0;
	
	return self;
}

- (void)dealloc
{
	int i;
	// 释放储存的图片
	for (i = 0; i < GAME_TIMERSTEPS; i++)
		[mProgressImage[i] release];	
	// 完成
	[super dealloc];
}

#pragma mark -
- (void)setPosition:(int)position
{
	[self setImage:mProgressImage[position]];
	mPosition = position;
}

@end
