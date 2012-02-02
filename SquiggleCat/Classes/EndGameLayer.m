//
//  EndGameLayer.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/1/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "EndGameLayer.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "AnimatedButton.h"

@implementation EndGameLayer

static const CGFloat BANNER_X = 160.0f;
static const CGFloat BANNER_Y = 300.0f;
static const CGFloat MENU_X = 90.0f;
static const CGFloat MENU_Y = 240.0f;
static const CGFloat RESTART_X = 200.0f;
static const CGFloat RESTART_Y = 240.0f;
static const CGFloat SCORE_X = 160.0f;
static const CGFloat SCORE_Y = 310.0f;

+ (id) endGameLayer:(NSInteger)score
{
    return [[[self alloc] initEndGameLayer:score] autorelease];
}

- (id) initEndGameLayer:(NSInteger)score
{
    if ((self = [super init])) {
        
        CCSprite *banner = [CCSprite spriteWithFile:@"Victory Banner.png"];
        banner.position = ccp(BANNER_X, BANNER_Y);
        [self addChild:banner];
        
        AnimatedButton *menuButton = [AnimatedButton buttonWithImage:@"Menu Text.png" target:self selector:@selector(mainMenu)];
        AnimatedButton *restartButton = [AnimatedButton buttonWithImage:@"Restart Text.png" target:self selector:@selector(restart)];  
        menuButton.position = ccp(MENU_X, MENU_Y);
        restartButton.position = ccp(RESTART_X, RESTART_Y);
        [self addChild:menuButton];
        [self addChild:restartButton];
        
        NSString *scoreText = [NSString stringWithFormat:@"%d", score];
        CCLabelBMFont *score = [CCLabelBMFont labelWithString:scoreText fntFile:@"Outline Font 28.fnt"];
        score.position = ccp(SCORE_X, SCORE_Y);
        [self addChild:score];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) mainMenu
{
    MenuScene *menuScene = [MenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:menuScene]];    
}

- (void) restart
{
    GameScene *gameScene = [GameScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:gameScene]];    
}

@end
