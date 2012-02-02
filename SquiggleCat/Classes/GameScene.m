//
//  GameScene.m
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "EndGameLayer.h"

@implementation GameScene

static const CGFloat GS_ENDGAME_MOVE_SPEED = 0.4f;

- (id) init
{
    if ((self = [super init])) {
        
        [self loadSpriteSheet];
        
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];
        
        GameLayer *gameLayer = [GameLayer node];
        [self addChild:gameLayer];
        
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOC
    NSLog(@"Menu Scene dealloc'd");
#endif
    
    [super dealloc];
}

- (void) loadSpriteSheet
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"spritesheet.png"];
    [self addChild:spriteSheet];
}

- (void) loadScoreScreen:(NSInteger)score
{
    CGSize size = [[CCDirector sharedDirector] winSize];    
    
    EndGameLayer *endGameLayer = [EndGameLayer endGameLayer:score];
    endGameLayer.position = ccp(size.width, 0);
    [self addChild:endGameLayer];

    id move = [CCMoveTo actionWithDuration:GS_ENDGAME_MOVE_SPEED position:ccp(0, 0)];
    [endGameLayer runAction:move];
}

@end
