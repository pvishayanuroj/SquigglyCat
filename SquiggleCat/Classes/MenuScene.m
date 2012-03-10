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
#import "ScoreScene.h"
#import "SimpleAudioEngine.h"
#import "GameCenterManager.h"

@implementation MenuScene

static const CGFloat MS_INSTRUCTION_MOVE_SPEED = 0.4f;

- (id) init
{
    if ((self = [super init])) {

        [self preloadSounds];
        
        [[GameCenterManager manager] authenticateLocalUser];
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        
        // Add title image
        
        CCSprite *title = [[CCSprite alloc] initWithFile:@"SquigeeTitle.png"];
        title.anchorPoint = CGPointZero;
        [self addChild:title];
        
        // Add menu buttons
        AnimatedButton *startButton = [AnimatedButton buttonWithImage:@"start.png" target:self selector:@selector(startGame)];
        AnimatedButton *helpButton = [AnimatedButton buttonWithImage:@"howto.png" target:self selector:@selector(showInstructions)];
        AnimatedButton *highScoreButton = [AnimatedButton buttonWithImage:@"hiscores.png" target:self selector:@selector(showScores)];
        
        startButton.position = CGPointMake(68, 200);
        helpButton.position = CGPointMake(120, 150);
        highScoreButton.position = CGPointMake(94, 100); 
        
        [self addChild:startButton];
        [self addChild:helpButton];
        [self addChild:highScoreButton];
        
        // Add instruction sheet
        instructions_ = [[AnimatedButton buttonWithImage:@"Instructions.png" target:self selector:@selector(hideInstructions)] retain];
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
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPaperFlip]; 
}

- (void) hideInstructions 
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    id moveIn = [CCMoveTo actionWithDuration:MS_INSTRUCTION_MOVE_SPEED position:ccp(640.0f, size.height / 2)];
	[instructions_ runAction:moveIn];
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPaperFlip]; 
}

- (void) showScores
{
    ScoreScene *scoreScene = [ScoreScene node];
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPaperFlip]; 
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:scoreScene]];
}

- (void) startGame 
{
    GameScene *gameScene = [GameScene node];
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPaperFlip]; 
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.5f scene:gameScene]];
}

- (void) preloadSounds
{
    // Initilaize bg music
    SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
    [sae preloadBackgroundMusic:kMusicRoadTrip];
    [sae preloadEffect:kSoundPaperFlip];
    [sae preloadEffect:kSoundWhistle];    
    [sae preloadEffect:kSoundClock];
    [sae preloadEffect:kSoundBirdChirps];
    [sae preloadEffect:kSoundBump];
    [sae preloadEffect:kSoundLitterbox];
    [sae preloadEffect:kSoundPoints];
    [sae preloadEffect:kSoundSquiggy];
    [sae preloadEffect:kSoundSlurp];
}

@end
