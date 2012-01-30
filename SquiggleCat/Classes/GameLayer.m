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

@implementation GameLayer

static const CGFloat GL_COLLISION_LOOP_SPEED = 1.0f/60.0f;
static const CGFloat GL_SPAWN_LOOP_SPEED = 1.0f;

static const CGFloat GL_CAT_START_X = 100.0f;
static const CGFloat GL_CAT_START_Y = 200.0f;

#pragma mark - Object Lifecycle

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        
        // Initialize the grid data variables
        numGridsX_ = 8;
        numGridsY_ = 8;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        gridSize_ = CGSizeMake(winSize.width / numGridsX_, winSize.height / numGridsY_);
        
        gridStatus_ = [[NSMutableSet set] retain];
        
        // Initialize the cat
        cat_ = [[Cat cat] retain];
        cat_.position = CGPointMake(GL_CAT_START_X, GL_CAT_START_Y);
        [self addChild:cat_ z:1];
        
        // Initialize data storage
        items_ = [[NSMutableArray array] retain];
        
        // Initialize loops
        [self schedule:@selector(collisionLoop:) interval:GL_COLLISION_LOOP_SPEED];
        [self schedule:@selector(spawnLoop:) interval:GL_SPAWN_LOOP_SPEED];   
        
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
        
        //DebugRect(@"cat r", catRect);
        //DebugRect(@"item r", itemRect);
        
        // If collision has occurred, have each item handle it's collison,
        // let the grid know the space is open, and record the index of that 
        // particular item
        //if (CGRectIntersectsRect(catRect, itemRect)) {
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

#pragma mark - Delegate Methods

- (void) itemCollided:(Item *)item
{
    switch (item.itemType) {
        case kItemFish:
            break;
        case kItemMilk:
            break;
        case kItemTrashCan:
            break;
        case kItemLitterBox:
            break;
        case kItemTeddyBear:
            break;
        default:
            NSAssert(NO, @"Invalid item type for itemCollided");
            break;
    }
}

#pragma mark - Touch Handlers

- (void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    CGFloat Velocity = 480.0/3.0;
    CGPoint moveDifference = ccpSub(touchLocation, cat_.position);
    float distanceToMove = ccpLength(moveDifference);
    float moveDuration = distanceToMove / Velocity;
    
    //NSLog(@"touchLocation: %f, player: %f",touchLocation.x, cat_.position.x);
    //NSLog(@"Move Difference: %f",moveDifference.x);
    
    if (moveDifference.x < 0) {
        if(cat_.scaleX > 0){
            cat_.scaleX *= -1;
        }
    } else {
        if(cat_.scaleX < 0){
            cat_.scaleX *= -1;
        }
    }    
    
    
    id moveAction = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:touchLocation],nil];
    [cat_ runAction:moveAction];
    //[player walk];
    
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

@end
