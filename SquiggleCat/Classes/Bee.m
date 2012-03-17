//
//  Bee.m
//  SquiggleCat
//
//  Created by Paul Vishayanuroj on 3/16/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "Bee.h"


@implementation Bee

static const CGFloat BEE_BB_X = 0.0f;
static const CGFloat BEE_BB_Y = 0.0f;
static const CGFloat BEE_BB_WIDTH = 30.0f;
static const CGFloat BEE_BB_HEIGHT = 30.0f;

- (id) init 
{
	if ((self = [super init])) {
        
        itemType_ = kItemBee;
        
        boundingBox_ = CGRectMake(BEE_BB_X, BEE_BB_Y, BEE_BB_WIDTH, BEE_BB_HEIGHT);
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"bee1.png"] retain];        
        [self addChild:sprite_ z:-1];
        
        [self initAnimation];
        [sprite_ runAction:animation_];
        
        [super spawnIn];        
    }
    
	return self;
}

- (void) collide {
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"trash.png"];
    [sprite_ setDisplayFrame: frame];
    
    [super collide];
}

- (void) dealloc
{   
    [sprite_ release];
    [animation_ release];
    
    [super dealloc];
}

- (void) initAnimation
{
    NSMutableArray *frames = [NSMutableArray array];
    [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bee1.png"]];    
    [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bee2.png"]];        
    
    CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:0.2f];
    animation_ = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]] retain];     
}

@end
