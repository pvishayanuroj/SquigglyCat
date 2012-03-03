//
//  PauseLayer.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/26/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "PauseLayer.h"
#import "AnimatedButton.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "SimpleAudioEngine.h"

@implementation PauseLayer

static const CGFloat PL_BANNER_X = 160.0f;
static const CGFloat PL_BANNER_Y = 240.0f;
static const CGFloat PL_MENU_X = 180.0f;
static const CGFloat PL_MENU_Y = 400.0f;
static const CGFloat PL_RESTART_X = 180.0f;
static const CGFloat PL_RESTART_Y = 340.0f;
static const CGFloat PL_RESUME_X = 180.0f;
static const CGFloat PL_RESUME_Y = 280.0f;

- (id) init
{
    if ((self = [super init])) {
        
        CCSprite *banner = [CCSprite spriteWithFile:@"ScoreResults.png"];
        banner.position = ccp(PL_BANNER_X, PL_BANNER_Y);
        [self addChild:banner];
        
        AnimatedButton *menuButton = [AnimatedButton buttonWithImage:@"Menu-Button.png" target:self selector:@selector(mainMenu)];
        AnimatedButton *restartButton = [AnimatedButton buttonWithImage:@"Replay-Button.png" target:self selector:@selector(restart)];          
        AnimatedButton *resumeButton = [AnimatedButton buttonWithImage:@"Replay-Button.png" target:self selector:@selector(resume)];    
        menuButton.position = ccp(PL_MENU_X, PL_MENU_Y);
        restartButton.position = ccp(PL_RESTART_X, PL_RESTART_Y);
        resumeButton.position = ccp(PL_RESUME_X, PL_RESUME_Y);
        [self addChild:menuButton];
        [self addChild:restartButton];        
        [self addChild:resumeButton];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) mainMenu
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPaperFlip];     
    MenuScene *menuScene = [MenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:menuScene]];    
}

- (void) restart
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPaperFlip];     
    GameScene *gameScene = [GameScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:gameScene]];    
}

- (void) resume
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPaperFlip];     
    GameScene *gameScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    [gameScene removePauseScreen];
}

@end
