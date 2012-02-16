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
#import "AnimatedButton.h"

@implementation GameLayer

static const CGFloat GL_COLLISION_LOOP_SPEED = 1.0f/60.0f;
static const CGFloat GL_SPAWN_LOOP_SPEED = 2.0f;
static const CGFloat GL_TIMER_LOOP_SPEED = 1.0f;

static const NSInteger GL_NUM_GRIDS_X = 6;
static const NSInteger GL_NUM_GRIDS_Y = 8;

static const NSInteger GL_NUM_USABLE_GRIDS_X = 6;	
static const NSInteger GL_NUM_USABLE_GRIDS_Y = 7;
static const NSInteger GL_LEVEL_TIME = 60;

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
        numGridsX_ = GL_NUM_USABLE_GRIDS_X;

        numGridsY_ = GL_NUM_USABLE_GRIDS_Y;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        gridSize_ = CGSizeMake(winSize.width / GL_NUM_GRIDS_X, winSize.height / GL_NUM_GRIDS_Y);
        
        gridStatus_ = [[NSMutableSet set] retain];
        
        //I think the button is too small.. hard to tap, I think I'll draw up a new one
        restartButton_ = [AnimatedButton buttonWithImage:@"returnBtn.png" target:self selector:@selector(restartButton)];

        [self addChild:restartButton_ z:2];
        [restartButton_ setPosition:ccp(290,455)];
        
        
        // Initialize timer and score
        scoreText_ = [[IncrementingText incrementingText] retain];
        scoreText_.position = ccp(GL_SCORE_X, GL_SCORE_Y);
        // highscoreLabel_.scale = 0.8f;
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

- (void) restartButton
{
    //RESTART!!
    //I added the code, then it crashes hahahaha
    //Dude, can you make it such that the cat can't travel a certain threshold? e.g. The cat doesn't go to the black bar on top.
    
}

- (void) dealloc
{
    [gridStatus_ release];
    [items_ release];
    [cat_ release];
    [timerLabel_ release];
    [scoreText_ release];    
    [restartButton_ release];
    
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
        
        // For fish, force a spawn
        if (i == kItemFish) {
            
            // Prevents an infinite loop
            if ([gridStatus_ count] < numGridsX_ * numGridsY_) {
                NSInteger x;
                NSInteger y;
                Pair *coord;
                do {
                    x = arc4random() % numGridsX_;
                    y = arc4random() % numGridsY_;        
                    coord = [Pair pair:x second:y];                    
                }
                while ([gridStatus_ containsObject:coord]);
                
                [gridStatus_ addObject:coord];
                [self addItem:i gridPos:coord];                
            }
        }
        else {
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
    //Add Another Fish!!
    // Generate a random coordinate
    NSInteger x = arc4random() % numGridsX_;
    NSInteger y = arc4random() % numGridsY_;        
    Pair *coord = [Pair pair:x second:y];
    
    // If spot isn't already taken, add the item
    if (![gridStatus_ containsObject:coord]) {
        [gridStatus_ addObject:coord];
        [self addItem:kItemFish gridPos:coord];
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
    
    //Check if Cat's Milky Time meter is ON (i.e. > 0)
    // each second Milky Time meter gets reduced and once it is equal to 0, MilkyTime ends
    if (cat_.milkyTimeMeter_ > 0)
        cat_.milkyTimeMeter_--;
    if(cat_.milkyTimeMeter_ <=0)
        [cat_ endMilkyTime];
    
    
}

#pragma mark - Delegate Methods

- (void) itemCollided:(Item *)item
{
    ItemType itemType = item.itemType;
    if (itemType == kItemFish) {
        scoreText_.score += 100;   
    }
    else if (itemType == kItemTeddyBear || itemType == kItemTrashCan || itemType == kItemLitterBox) {
        if(cat_.milkyTimeMeter_<=0){
            //If MilkyTime meter is 0, then freeze cat
        [self freezeCat];
        }
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
    // +1 offset to account for case where x and or y are 0
    return CGPointMake((gridPos.x + 1) * gridSize_.width  - gridSize_.width / 2, (gridPos.y + 1) * gridSize_.height - gridSize_.height / 2);
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
