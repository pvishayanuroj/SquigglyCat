//
//  GameScene.m
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"

@implementation GameScene

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

- (void)dealloc
{
    [super dealloc];
}

- (void) loadSpriteSheet
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"spritesheet.png"];
    [self addChild:spriteSheet];
}

@end
