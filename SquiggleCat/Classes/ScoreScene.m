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
#import "SimpleAudioEngine.h"
#import "ScoreUtility.h"
#import "GameCenterManager.h"

@implementation ScoreScene

static const CGFloat SS_NAME_X = 20.0f;
static const CGFloat SS_SCORE_X = 200.0f;
static const CGFloat SS_LIST_Y = 380.0f;
static const CGFloat SS_LIST_PADDING = 32.0f;

static const CGFloat SS_MENU_X = 60.0f;
static const CGFloat SS_MENU_Y = 30.0f;
static const CGFloat SS_LOCAL_X = 160.0f;
static const CGFloat SS_LOCAL_Y = 30.0f;
static const CGFloat SS_GLOBAL_X = 250.0f;
static const CGFloat SS_GLOBAL_Y = 30.0f;
static const CGFloat SS_TITLE_X = 160.0f;
static const CGFloat SS_TITLE_Y = 412.0f;

static const CGFloat SS_FONT_SCALE = 0.5f;

- (id) init
{
    if ((self = [super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"highscore-screen.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];        
        
        AnimatedButton *menuButton = [AnimatedButton buttonWithImage:@"back.png" target:self selector:@selector(mainMenu)];
        menuButton.position = ccp(SS_MENU_X, SS_MENU_Y);
        [self addChild:menuButton];  
        
        labels_ = [[NSMutableArray array] retain];
        
        title_ = [[CCLabelBMFont labelWithString:@"" fntFile:@"SquiggyF.fnt"] retain];
        title_.position = ccp(SS_TITLE_X, SS_TITLE_Y);
        [self addChild:title_];        
        
        localButton_ = [[AnimatedButton buttonWithImage:@"local-greyed.png" target:self selector:@selector(localButton)] retain];
        localButton_.position = ccp(SS_LOCAL_X, SS_LOCAL_Y);                     
        globalButton_ = [[AnimatedButton buttonWithImage:@"global-greyed.png" target:self selector:@selector(globalButton)] retain];
        globalButton_.position = ccp(SS_GLOBAL_X, SS_GLOBAL_Y);
        
        [self localButton];
        
        [self addChild:localButton_];          
        [self addChild:globalButton_];               
    }
    return self;
}

- (void) dealloc
{
    [GameCenterManager manager].delegate = nil;
    
    [labels_ release];
    [title_ release];
    [globalButton_ release];
    [localButton_ release];
    
    [super dealloc];
}

- (void) showHighScores:(NSArray *)scores showName:(BOOL)showName
{
    NSArray *sortedScores = [scores sortedArrayUsingSelector:@selector(compare:)];
    
    NSUInteger index = 0;
    for (Score *score in sortedScores) {
        
        CCLabelBMFont *nameLabel;
        CCLabelBMFont *scoreLabel;
        NSString *nameText;
        NSString *scoreText;
        
        if (showName) {
            nameText = [NSString stringWithFormat:@"%d. %@", index + 1, score.name];
        }
        else {
            nameText = [NSString stringWithFormat:@"%d.", index + 1];
        }
        
        scoreText = [NSString stringWithFormat:@"%d", score.value];        
        nameLabel = [CCLabelBMFont labelWithString:nameText fntFile:@"SquiggyF.fnt"];            
        scoreLabel = [CCLabelBMFont labelWithString:scoreText fntFile:@"SquiggyF.fnt"];           
        nameLabel.anchorPoint = ccp(0, 0.5f);
        scoreLabel.anchorPoint = ccp(1, 0.5f);        
        nameLabel.scale = SS_FONT_SCALE;
        scoreLabel.scale = SS_FONT_SCALE;        
        nameLabel.position = ccp(SS_NAME_X, -(index * SS_LIST_PADDING) + SS_LIST_Y);
        scoreLabel.position = ccp(SS_SCORE_X, -(index * SS_LIST_PADDING) + SS_LIST_Y);            
        [self addChild:nameLabel];
        [self addChild:scoreLabel];     
        [labels_ addObject:nameLabel];
        [labels_ addObject:scoreLabel];
        index++;
    }
}

- (void) removeAllLabels
{
    for (CCNode *node in labels_) {
        [node removeFromParentAndCleanup:YES];
    }
    [labels_ removeAllObjects];
}

- (void) mainMenu
{
    MenuScene *menuScene = [MenuScene node];
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPaperFlip];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:menuScene]];    
}

- (void) localButton
{
    localButton_.isLocked = YES;
    globalButton_.isLocked = NO;
    [localButton_ updateImage:@"local.png"];
    [globalButton_ updateImage:@"global-greyed.png"];   
    
    [title_ setString:@"Local Scores"];
    [title_ setScale:0.8f];
    [self removeAllLabels];
    [self showHighScores:[ScoreUtility getLocalScores] showName:NO];
}

- (void) globalButton
{
    localButton_.isLocked = NO;
    globalButton_.isLocked = YES;
    [localButton_ updateImage:@"local-greyed.png"];
    [globalButton_ updateImage:@"global.png"];    
    
    [title_ setString:@"Global Scores"];
    [title_ setScale:0.8f];

    [self removeAllLabels];
    
    GameCenterManager *manager = [GameCenterManager manager];
    manager.delegate = self;
    [manager retrieveTopTenScores];
}

- (void) leaderboardRetrieved:(NSArray *)scores
{
    NSMutableArray *globalScores = [NSMutableArray array];
    for (GKScore *scoreGK in scores) {
        Score *score = [Score score:scoreGK.playerID value:(NSInteger)scoreGK.value];
        [globalScores addObject:score];
    }
    [self showHighScores:globalScores showName:YES];
}

@end
