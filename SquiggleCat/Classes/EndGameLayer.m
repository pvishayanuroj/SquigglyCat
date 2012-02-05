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
static const CGFloat BANNER_Y = 240.0f;
static const CGFloat MENU_X = 180.0f;
static const CGFloat MENU_Y = 320.0f;
static const CGFloat RESTART_X = 180.0f;
static const CGFloat RESTART_Y = 260.0f;
static const CGFloat SCORE_X = 160.0f;
static const CGFloat SCORE_Y = 420.0f;

+ (id) endGameLayer:(NSInteger)score
{
    return [[[self alloc] initEndGameLayer:score] autorelease];
}

- (id) initEndGameLayer:(NSInteger)score
{
    if ((self = [super init])) {
        
        CCSprite *banner = [CCSprite spriteWithFile:@"ScoreResults.png"];
        banner.position = ccp(BANNER_X, BANNER_Y);
        [self addChild:banner];
        
        AnimatedButton *menuButton = [AnimatedButton buttonWithImage:@"Menu-Button.png" target:self selector:@selector(mainMenu)];
        AnimatedButton *restartButton = [AnimatedButton buttonWithImage:@"Replay-Button.png" target:self selector:@selector(restart)];  
        menuButton.position = ccp(MENU_X, MENU_Y);
        restartButton.position = ccp(RESTART_X, RESTART_Y);
        [self addChild:menuButton];
        [self addChild:restartButton];
        
        NSString *scoreText = [NSString stringWithFormat:@"%d", score];
        CCLabelBMFont *score = [CCLabelBMFont labelWithString:scoreText fntFile:@"SquigglyWhite.fnt"];
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
