//
//  GameLayer.m
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "GameLayer.h"
#import "Item.h"
#import "Cat.h"
#import "Pair.h"
#import "Fish.h"
#import "Milk.h"
#import "Teddy.h"
#import "Litterbox.h"
#import "TrashCan.h"
#import "Utility.h"
#import "MenuScene.h"
#import "IncrementingText.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"

@implementation GameLayer

static const CGFloat GL_COLLISION_LOOP_SPEED = 1.0f/60.0f;
static const CGFloat GL_SPAWN_LOOP_SPEED = 2.0f;
static const CGFloat GL_TIMER_LOOP_SPEED = 1.0f;

static const NSInteger GL_LEVEL_TIME = 20;

static const CGFloat GL_SCORE_X = 150.0f;
static const CGFloat GL_SCORE_Y = 460.0f;
static const CGFloat GL_TIMER_X = 40.0f;
static const CGFloat GL_TIMER_Y = 460.0f;

static const CGFloat GL_CAT_START_X = 100.0f;
static const CGFloat GL_CAT_START_Y = 200.0f;

static const CGFloat GL_FREEZE_DURATION = 1.0f;

#pragma mark - Object Lifecycle

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        isCatFrozen_ = NO;
        //clickEnabled_ = YES;
        
        // Initialize the grid data variables
        numGridsX_ = 6;
        numGridsY_ = 8;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        gridSize_ = CGSizeMake(winSize.width / numGridsX_, winSize.height / numGridsY_);
        
        gridStatus_ = [[NSMutableSet set] retain];
        
        // Initialize timer and score
        scoreText_ = [[IncrementingText incrementingText] retain];
        scoreText_.position = ccp(GL_SCORE_X, GL_SCORE_Y);
//        highscoreLabel_.scale = 0.8f;
        [self addChild:scoreText_];
        
        timer_ = GL_LEVEL_TIME;
        NSString *timeText = [NSString stringWithFormat:@"%d", timer_];
        timerLabel_ = [[CCLabelBMFont labelWithString:timeText fntFile:@"SquigglyWhite.fnt"] retain];
        timerLabel_.position = ccp(GL_TIMER_X, GL_TIMER_Y);
        timerLabel_.scale = 0.75f;
        [self addChild:timerLabel_];        
        
        // Initialize the cat
        cat_ = [[Cat cat] retain];
        cat_.position = CGPointMake(GL_CAT_START_X, GL_CAT_START_Y);
        [self addChild:cat_ z:1];
        
        // Initialize data storage
        items_ = [[NSMutableArray array] retain];
        
        // Initilaize bg music
        SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
        if (sae != nil) {
            [sae preloadBackgroundMusic:@"Roadtrip Long.caf"];
            if (sae.willPlayBackgroundMusic) {
                sae.backgroundMusicVolume = 0.25f;
            }
        }
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Roadtrip Long.caf"];//play background music
        
        // Initialize loops
        [self schedule:@selector(collisionLoop:) interval:GL_COLLISION_LOOP_SPEED];
        [self schedule:@selector(spawnLoop:) interval:GL_SPAWN_LOOP_SPEED];  
        [self schedule:@selector(timerLoop:) interval:GL_TIMER_LOOP_SPEED];          
        
        /* WTF Apple???
        CGRect t1 = CGRectMake(83, 84, 40, 32);
        CGRect t2 = CGRectMake(60, 90, 16, 28);
        
        if (CGRectIntersectsRect(t1, t2)) {
            NSLog(@"TRUETRUETRUE");
        }
        else {
            NSLog(@"FALSEFASLSE");
        }
         */
    }
    return self;
}

- (void) dealloc
{
    [gridStatus_ release];
    [items_ release];
    [cat_ release];
    [timerLabel_ release];
    [scoreText_ release];    
    
    [super dealloc];
}

#pragma mark - Looping Operations

- (void) collisionLoop:(ccTime)dt
{
    CGRect catRect = [cat_ boundingBoxInWorldCoord];
    
    NSMutableIndexSet *toRemove = [NSMutableIndexSet indexSet];
    NSInteger index = 0;
    
    // For all items in the world
    for (Item *item in items_) {
        
        CGRect itemRect = [item boundingBoxInWorldCoord];
        
        // If collision has occurred, have each item handle it's collison,
        // let the grid know the space is open, and record the index of that 
        // particular item
        if ([Utility intersects:catRect b:itemRect]) {
            [item collide];
            [gridStatus_ removeObject:item.gridPos];
            [toRemove addIndex:index];
        }
        
        index++;
    }
    
    // Remove all collided items from future collision checks
    [items_ removeObjectsAtIndexes:toRemove];
}

- (void) spawnLoop:(ccTime)dt
{
    for (NSUInteger i = 0; i < kNumItemTypes; ++i) {
        
        // Generate a random coordinate
        NSInteger x = arc4random() % numGridsX_;
        NSInteger y = arc4random() % numGridsY_;        
        Pair *coord = [Pair pair:x second:y];
        
        // If spot isn't already taken, add the item
        if (![gridStatus_ containsObject:coord]) {
            [gridStatus_ addObject:coord];
            [self addItem:i gridPos:coord];
        }
    }
}

- (void) timerLoop:(ccTime)dt
{
    timer_--;
    if (timer_ < 0) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"Whistle 1.caf"];  
        [self endLevel];
    }
    else {
        [timerLabel_ setString:[NSString stringWithFormat:@"%d", timer_]];
    }
    if (timer_ == 10){
        //Play clock tick when there's 10 seconds left!
        [[SimpleAudioEngine sharedEngine] playEffect:@"clock.wav"];  
        NSLog(@"Tick Tock!");
    }
    
}

#pragma mark - Delegate Methods

- (void) itemCollided:(Item *)item
{
    ItemType itemType = item.itemType;
    if (itemType == kItemFish) {
        scoreText_.score += 100;
    }
    else if (itemType == kItemTeddyBear || itemType == kItemTrashCan || itemType == kItemLitterBox) {
        [self freezeCat];
    }
    
    [cat_ catCollide:itemType];
}

#pragma mark - Touch Handlers

- (void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return !isCatFrozen_;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isCatFrozen_) {
        CGPoint touchLocation = [touch locationInView: [touch view]];		
        touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        
        [cat_ walkTo:touchLocation];
        
        //DebugPoint(@"move", touchLocation);
        cat_.moveTarget = touchLocation;   
    }
}

#pragma mark - Helper Methods

- (void) addItem:(ItemType)itemType gridPos:(Pair *)gridPos
{
    Item *item;
    
    switch (itemType) {
        case kItemFish:
            item = [Fish node];
            break;
        case kItemMilk:
            item = [Milk node];
            break;
        case kItemLitterBox:
            item = [Litterbox node];
            break;
        case kItemTrashCan:
            item = [TrashCan node];
            break;
        case kItemTeddyBear:
            item = [Teddy node];
            break;
        default:
            NSAssert(NO, @"Invalid item type for addItem");
            break;
    }
    
    item.delegate = self;
    item.gridPos = gridPos;
    item.position = [self posFromGridPos:gridPos];
    [items_ addObject:item];
    [self addChild:item z:0];
}

- (CGPoint) posFromGridPos:(Pair *)gridPos
{
    return CGPointMake(gridPos.x * gridSize_.width  - gridSize_.width / 2, gridPos.y * gridSize_.height - gridSize_.height / 2);
}

- (void) endLevel
{
    [cat_ stopAllActions];
    
    [self unschedule:@selector(spawnLoop:)];
    [self unschedule:@selector(collisionLoop:)];
    [self unschedule:@selector(timerLoop:)];
    
    self.isTouchEnabled = NO;
    
    GameScene *gameScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    [gameScene loadScoreScreen:scoreText_.score];
}

- (void) freezeCat
{
    isCatFrozen_ = YES;    
    id delay = [CCDelayTime actionWithDuration:GL_FREEZE_DURATION];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(unfreezeCat)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) unfreezeCat
{
    isCatFrozen_ = NO;
}

@end
