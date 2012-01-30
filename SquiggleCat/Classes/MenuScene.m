//
//  MenuScene.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "AnimatedButton.h"

@implementation MenuScene

static const CGFloat MS_INSTRUCTION_MOVE_SPEED = 0.4f;

- (id) init
{
    if ((self = [super init])) {

		CGSize size = [[CCDirector sharedDirector] winSize];        
        
        // Add background and title
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.anchorPoint = CGPointZero;
		[self addChild:background];
        
        CCSprite *title = [[CCSprite alloc] initWithFile:@"SquigeeHeader.png"];
        title.anchorPoint = CGPointZero;
        [self addChild:title];
        
        // Add menu buttons
        AnimatedButton *startButton = [AnimatedButton buttonWithImage:@"StartButton.png" target:self selector:@selector(startGame)];
        AnimatedButton *helpButton = [AnimatedButton buttonWithImage:@"HowToButton.png" target:self selector:@selector(showInstructions)];
        AnimatedButton *highScoreButton = [AnimatedButton buttonWithImage:@"HiScoresButton.png" target:self selector:@selector(showScores)];
        
        startButton.position = CGPointMake(50, 200);
        helpButton.position = CGPointMake(100, 150);
        highScoreButton.position = CGPointMake(95, 100); 
        
        [self addChild:startButton];
        [self addChild:helpButton];
        [self addChild:highScoreButton];
        
        // Add instruction sheet
        instructions_ = [[AnimatedButton buttonWithImage:@"SquigeeInstructions.png" target:self selector:@selector(hideInstructions)] retain];
        instructions_.position = ccp(640, size.height / 2);
        [self addChild:instructions_];        
        
    }
    
    return self;
}

- (void) dealloc
{
    [instructions_ release];
    
    [super dealloc];
}

- (void) showInstructions 
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    id moveIn = [CCMoveTo actionWithDuration:MS_INSTRUCTION_MOVE_SPEED position:ccp(size.width / 2, size.height / 2)];
	[instructions_ runAction:moveIn];
}

- (void) hideInstructions 
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    id moveIn = [CCMoveTo actionWithDuration:MS_INSTRUCTION_MOVE_SPEED position:ccp(640.0f, size.height / 2)];
	[instructions_ runAction:moveIn];
}

- (void) showScores
{
    
}

- (void) startGame 
{
    GameScene *gameScene = [GameScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:gameScene]];
}

@end
