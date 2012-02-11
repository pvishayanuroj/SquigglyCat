//
//  ScoreScene.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/10/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "ScoreScene.h"
#import "Score.h"
#import "AnimatedButton.h"
#import "MenuScene.h"

@implementation ScoreScene

static const CGFloat SS_NAME_X = 20.0f;
static const CGFloat SS_SCORE_X = 300.0f;
static const CGFloat SS_LIST_Y = 380.0f;
static const CGFloat SS_LIST_PADDING = 32.0f;

static const CGFloat SS_MENU_X = 60.0f;
static const CGFloat SS_MENU_Y = 30.0f;

static const CGFloat SS_FONT_SCALE = 0.5f;

- (id) init
{
    if ((self = [super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];        
        
        AnimatedButton *menuButton = [AnimatedButton buttonWithImage:@"Menu-Button.png" target:self selector:@selector(mainMenu)];
        menuButton.position = ccp(SS_MENU_X, SS_MENU_Y);
        [self addChild:menuButton];        
        
        // Test
        NSMutableArray *a = [NSMutableArray array];
        [a addObject:[Score score:@"Paul" value:300]];
        [a addObject:[Score score:@"Jamorn" value:1000]];
        [a addObject:[Score score:@"Dan" value:2000]];        
        [a addObject:[Score score:@"Joss" value:200]];        
        [a addObject:[Score score:@"Alex" value:1500]];        
        [a addObject:[Score score:@"Kin" value:10000]];        
        [a addObject:[Score score:@"Gig" value:200]];        
        [a addObject:[Score score:@"Patrick" value:20]];        
        [a addObject:[Score score:@"Lin" value:100]];        
        [a addObject:[Score score:@"Kobe" value:100]];                
        [self showHighScores:a];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) showHighScores:(NSArray *)scores
{
    NSArray *sortedScores = [scores sortedArrayUsingSelector:@selector(compare:)];
    
    NSUInteger index = 0;
    for (Score *score in sortedScores) {
        
        NSString *nameText = [NSString stringWithFormat:@"%d. %@", index + 1, score.name];
        NSString *scoreText = [NSString stringWithFormat:@"%d", score.value];        
        CCLabelBMFont *nameLabel = [CCLabelBMFont labelWithString:nameText fntFile:@"SquigglyWhite.fnt"];            
        CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:scoreText fntFile:@"SquigglyWhite.fnt"];
        nameLabel.anchorPoint = ccp(0, 0.5f);
        scoreLabel.anchorPoint = ccp(1, 0.5f);
        nameLabel.scale = SS_FONT_SCALE;
        scoreLabel.scale = SS_FONT_SCALE;
        nameLabel.position = ccp(SS_NAME_X, -(index * SS_LIST_PADDING) + SS_LIST_Y);
        scoreLabel.position = ccp(SS_SCORE_X, -(index * SS_LIST_PADDING) + SS_LIST_Y);    
        [self addChild:nameLabel];
        [self addChild:scoreLabel];
        index++;
    }
}

- (void) mainMenu
{
    MenuScene *menuScene = [MenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:menuScene]];    
}


@end
