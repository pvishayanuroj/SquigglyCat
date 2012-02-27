//
//  ScoreScene.h
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/10/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GameCenterManagerDelegate.h"

@class AnimatedButton;

@interface ScoreScene : CCScene <GameCenterManagerDelegate> {
    
    NSMutableArray *labels_;
    
    CCLabelBMFont *title_;
    
    AnimatedButton *localButton_;
    
    AnimatedButton *globalButton_;
}

- (void) showHighScores:(NSArray *)scores showName:(BOOL)showName;

- (void) localButton;

- (void) globalButton;

@end
