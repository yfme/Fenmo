//
//  FenmoTimerView.h
//  Fenmo
//
//  Created by yang on 10-11-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenmoGame.h"

@interface FenmoTimerView : UIImageView
{
	UIImage		*mProgressImage[GAME_TIMERSTEPS];
	int			mPosition;
}

- (id)init;
- (void)setPosition:(int)position;

@end
