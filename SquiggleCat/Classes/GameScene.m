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
#import "PauseLayer.h"

@implementation GameScene

static const CGFloat GS_ENDGAME_MOVE_SPEED = 0.4f;

- (id) init
{
    if ((self = [super init])) {
        
        [self loadSpriteSheet];
        
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];
        
        gameLayer_ = [[GameLayer node] retain];
        [self addChild:gameLayer_];
        
        pauseLayer_ = nil;
        
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOC
    NSLog(@"Menu Scene dealloc'd");
#endif
    
    [gameLayer_ release];
    [pauseLayer_ release];
    
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
    endGameLayer.position = ccp(0, size.height);
    [self addChild:endGameLayer];

    id move = [CCMoveTo actionWithDuration:GS_ENDGAME_MOVE_SPEED position:ccp(0, 0)];
    [endGameLayer runAction:move];
}

- (void) loadPauseScreen
{
    CGSize size = [[CCDirector sharedDirector] winSize];    
    
    if (pauseLayer_ == nil) {
        pauseLayer_ = [[PauseLayer node] retain];
        pauseLayer_.position = ccp(0, size.height);
        [self addChild:pauseLayer_];
    }
    
    id move = [CCMoveTo actionWithDuration:GS_ENDGAME_MOVE_SPEED position:ccp(0, 0)];
    [pauseLayer_ runAction:move];
}

- (void) removePauseScreen
{
    CGSize size = [[CCDirector sharedDirector] winSize];     
    
    id move = [CCMoveTo actionWithDuration:GS_ENDGAME_MOVE_SPEED position:ccp(0, size.height)];    
    id done = [CCCallFunc actionWithTarget:self selector:@selector(resumeGame)];
    [pauseLayer_ runAction:[CCSequence actions:move, done, nil]];    
}

- (void) resumeGame
{
    [gameLayer_ resumeGame];
}

@end
