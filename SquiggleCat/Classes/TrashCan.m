//
//  TrashCan.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TrashCan.h"

@implementation TrashCan

static const CGFloat TC_BB_X = 0.0f;
static const CGFloat TC_BB_Y = 0.0f;
static const CGFloat TC_BB_WIDTH = 40.0f;
static const CGFloat TC_BB_HEIGHT = 60.0f;

- (id) init 
{
	if ((self = [super init])) {
        
        itemType_ = kItemTrashCan;
        
        boundingBox_ = CGRectMake(TC_BB_X, TC_BB_Y, TC_BB_WIDTH, TC_BB_HEIGHT);

        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"trash.png"] retain];        
        [self addChild:sprite_ z:-1];
        
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
    
    [super dealloc];
}

@end
