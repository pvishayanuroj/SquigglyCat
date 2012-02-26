//
//  GameScene.h
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;
@class PauseLayer;

@interface GameScene : CCScene {
 
    GameLayer *gameLayer_;
    
    PauseLayer *pauseLayer_;
    
}

- (void) loadSpriteSheet;

- (void) loadScoreScreen:(NSInteger)score;

- (void) loadPauseScreen;

- (void) removePauseScreen;

@end
