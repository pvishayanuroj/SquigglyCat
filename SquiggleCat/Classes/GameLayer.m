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
#import "Bee.h"
#import "Litterbox.h"
#import "TrashCan.h"
#import "Utility.h"
#import "MenuScene.h"
#import "IncrementingText.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "AnimatedButton.h"
#import "CCNode+PauseResume.h"
#import "Banners.h"

@implementation GameLayer

static const CGFloat GL_COLLISION_LOOP_SPEED = 1.0f/60.0f;
static const CGFloat GL_SPAWN_LOOP_SPEED = 2.0f;
static const CGFloat GL_TIMER_LOOP_SPEED = 1.0f;

static const NSInteger GL_NUM_GRIDS_X = 6;
static const NSInteger GL_NUM_GRIDS_Y = 8;

// These values control how far off center of a tile the cat can be before 
// being considered ALSO in the adjacent tile
static const CGFloat GL_CAT_WIDTH_FACTOR = 0.5f;
static const CGFloat GL_CAT_HEIGHT_FACTOR = 0.5f;

static const CGFloat GL_BOUNDARY_Y = 420.0f;

static const NSInteger GL_NUM_USABLE_GRIDS_X = 6;	
static const NSInteger GL_NUM_USABLE_GRIDS_Y = 7;
static const NSInteger GL_LEVEL_TIME = 60;

static const CGFloat GL_SCORE_X = 110.0f;
static const CGFloat GL_SCORE_Y = 455.0f;
static const CGFloat GL_TIMER_X = 25.0f;
static const CGFloat GL_TIMER_Y = 455.0f;

static const CGFloat GL_CAT_START_X = 100.0f;
static const CGFloat GL_CAT_START_Y = 200.0f;

static const CGFloat GL_BANNER_START_X = -200.0f;
static const CGFloat GL_BANNER_START_Y = 320.0f;

static const NSInteger NUM_FISH_PER_CYCLE = 2;

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
        
        pauseButton_ = [[AnimatedButton buttonWithImage:@"pauseBtn.png" target:self selector:@selector(pauseGame)] retain];

        [self addChild:pauseButton_ z:2];
        [pauseButton_ setPosition:ccp(290,455)];
        
        
        // Initialize timer and score
        scoreText_ = [[IncrementingText incrementingText] retain];
        scoreText_.position = ccp(GL_SCORE_X, GL_SCORE_Y);
        // highscoreLabel_.scale = 0.8f;
        [self addChild:scoreText_];
        
        timer_ = GL_LEVEL_TIME;
        NSString *timeText = [NSString stringWithFormat:@"%d", timer_];
        timerLabel_ = [[CCLabelBMFont labelWithString:timeText fntFile:@"SquiggyF.fnt"] retain];
        timerLabel_.position = ccp(GL_TIMER_X, GL_TIMER_Y);
        timerLabel_.scale = 0.75f;
        [self addChild:timerLabel_];        
        
        // Initialize the cat
        cat_ = [[Cat cat] retain];
        cat_.position = CGPointMake(GL_CAT_START_X, GL_CAT_START_Y);
        [self addChild:cat_ z:1];
        
        // Initialize data storage
        items_ = [[NSMutableArray array] retain];
        
        // Play background music
        SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
        if (sae.willPlayBackgroundMusic) {
            sae.backgroundMusicVolume = 0.25f;
            [sae playBackgroundMusic:kMusicRoadTrip];
        }
        
        // Initialize banners
        comboBanner_ = [[Banners banner] retain];
        comboBanner_.position = CGPointMake(GL_BANNER_START_X, GL_BANNER_START_Y);
        [self addChild:comboBanner_ z:5];
        
        // Initialize loops
        [self schedule:@selector(collisionLoop:) interval:GL_COLLISION_LOOP_SPEED];
        [self schedule:@selector(spawnLoop:) interval:GL_SPAWN_LOOP_SPEED];  
        [self schedule:@selector(timerLoop:) interval:GL_TIMER_LOOP_SPEED];          
        
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
    [pauseButton_ release];
    [comboBanner_ release];
    
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
    // Determine the grid position of the cat
    NSSet *catTiles = [self tilesTouchingCat];
    
    for (NSUInteger i = 0; i < kNumItemTypes; ++i) {
        
        // For fish, force a spawn
        if (i == kItemFish) {
            
            for (NSInteger j = 0; j < NUM_FISH_PER_CYCLE; j++) {
                NSSet *allTiles = [Utility allGridTiles:GL_NUM_USABLE_GRIDS_X height:GL_NUM_USABLE_GRIDS_Y];
                NSSet *allTilesLessItems = [Utility setSubtraction:allTiles b:gridStatus_];
                NSSet *remainingTiles = [Utility setSubtraction:allTilesLessItems b:catTiles];
                
                Pair *coord = (Pair *)[Utility randomObjectFromSet:remainingTiles];
                
                if (coord != nil) {
                    [gridStatus_ addObject:coord];
                    [self addItem:i gridPos:coord];                               
                }
            }
        }
        // For any other item, try for a random spot, but if anything is there, no need to add
        else {
            // Generate a random coordinate
            NSInteger x = arc4random() % numGridsX_;
            NSInteger y = arc4random() % numGridsY_;        
            Pair *coord = [Pair pair:x second:y];
            
            // If spot isn't already taken, add the item
            if (![gridStatus_ containsObject:coord] && ![catTiles containsObject:coord]) {
                [gridStatus_ addObject:coord];
                [self addItem:i gridPos:coord];
            }            
        }
    }
}

- (void) timerLoop:(ccTime)dt
{
    timer_--;
    if (timer_ < 0) {
        [[SimpleAudioEngine sharedEngine] playEffect:kSoundWhistle];  
        [self endLevel];
    }
    else {
        [timerLabel_ setString:[NSString stringWithFormat:@"%d", timer_]];
    }
    if (timer_ == 10){
        //Play clock tick when there's 10 seconds left!
        [[SimpleAudioEngine sharedEngine] playEffect:kSoundClock];  
    }
    
    //Check if Cat's Milky Time meter is ON (i.e. > 0)
    // each second Milky Time meter gets reduced and once it is equal to 0, MilkyTime ends
    if (cat_.milkyTimeMeter_ > 0)
        cat_.milkyTimeMeter_--;
    if(cat_.milkyTimeMeter_ <=0)
        [cat_ endMilkyTime];
    
    if (cat_.milkyTimeMeter_ ==2)
        [comboBanner_ runSlideIn];
    
}

#pragma mark - Delegate Methods

- (void) itemCollided:(Item *)item
{
    ItemType itemType = item.itemType;
    if (itemType == kItemFish) {
        scoreText_.score += 100;   
    }
    else if (itemType == kItemTeddyBear || itemType == kItemTrashCan || itemType == kItemLitterBox || itemType == kItemBee) {
        if (cat_.milkyTimeMeter_ <= 0) {
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
    if (!isCatFrozen_) {
        CGPoint touchLocation = [touch locationInView: [touch view]];		
        touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        
        // Do not let the player move into the empty space
        if (touchLocation.y > GL_BOUNDARY_Y) {
            return NO;
        }        
        return YES;
    }
    return NO;
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
        
        // Do not let the player move into the empty space
        if (touchLocation.y > GL_BOUNDARY_Y) {
            touchLocation.y = GL_BOUNDARY_Y;
        }
        
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
        case kItemBee:
            item = [Bee node];
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

- (Pair *) gridPosFromPos:(CGPoint)pos
{
    NSInteger x = ((NSInteger)pos.x) / ((NSInteger)gridSize_.width);
    NSInteger y = ((NSInteger)pos.y) / ((NSInteger)gridSize_.height);
    return [Pair pair:x second:y];
}

- (CGPoint) posFromGridPos:(Pair *)gridPos
{
    // +1 offset to account for case where x and or y are 0
    return CGPointMake(gridPos.x * gridSize_.width  + gridSize_.width / 2, gridPos.y * gridSize_.height + gridSize_.height / 2);
}

- (NSSet *) tilesTouchingCat
{
    NSMutableSet *tiles = [NSMutableSet setWithCapacity:3];
    
    NSInteger catX = (NSInteger)cat_.position.x;
    NSInteger catY = (NSInteger)cat_.position.y;
    
    NSInteger width = (NSInteger)gridSize_.width;
    NSInteger height = (NSInteger)gridSize_.height;
    
    NSInteger modX = catX % width;
    NSInteger modY = catY % height;
    
    NSInteger tileX = catX / width;
    NSInteger tileY = catY / height;
    
    [tiles addObject:[Pair pair:tileX second:tileY]];
    
    NSInteger leftBound = (NSInteger)(gridSize_.width * 0.5f - gridSize_.width * GL_CAT_WIDTH_FACTOR * 0.5f);
    NSInteger rightBound = (NSInteger)(gridSize_.width * 0.5f + gridSize_.width * GL_CAT_WIDTH_FACTOR * 0.5f);    
    NSInteger upperBound = (NSInteger)(gridSize_.height * 0.5f - gridSize_.height * GL_CAT_HEIGHT_FACTOR * 0.5f);
    NSInteger lowerBound = (NSInteger)(gridSize_.height * 0.5f + gridSize_.height * GL_CAT_HEIGHT_FACTOR * 0.5f);        
    
    BOOL leftFlag = modX < leftBound && tileX > 0;
    BOOL rightFlag = modX > rightBound && (tileX < GL_NUM_GRIDS_X - 1);
    BOOL lowerFlag = modY < lowerBound && tileY > 0;
    BOOL upperFlag = modY > upperBound && (tileY < GL_NUM_GRIDS_Y - 1);
    
    if (leftFlag) {
        [tiles addObject:[Pair pair:tileX - 1 second:tileY]];
    }
    else if (rightFlag) {
        [tiles addObject:[Pair pair:tileX + 1 second:tileY]];        
    }
    
    if (lowerFlag) {
        [tiles addObject:[Pair pair:tileX second:tileY - 1]];
    }
    else if (upperFlag) {
        [tiles addObject:[Pair pair:tileX second:tileY + 1]];        
    }
    
    // Check lower left
    if (leftFlag && lowerFlag) {
        [tiles addObject:[Pair pair:tileX - 1 second:tileY - 1]];
    }
    // Check lower right
    else if (rightFlag && lowerFlag) {
        [tiles addObject:[Pair pair:tileX + 1 second:tileY - 1]];
    }
    // Check upper left
    else if (leftFlag && upperFlag) {
        [tiles addObject:[Pair pair:tileX - 1 second:tileY + 1]];
    }
    // Check upper right
    else if (rightFlag && upperFlag) {
        [tiles addObject:[Pair pair:tileX + 1 second:tileY + 1]];
    }
    
    return tiles;
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

- (void) pauseGame
{
    [self pauseHierarchy];
    isCatFrozen_ = YES;
    
    GameScene *gameScene = (GameScene *)[[CCDirector sharedDirector] runningScene];
    [gameScene loadPauseScreen];
}

- (void) resumeGame
{
    [self resumeHierarchy];
    isCatFrozen_ = NO;
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
