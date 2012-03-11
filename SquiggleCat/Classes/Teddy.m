//
//  Teddy.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Teddy.h"


@implementation Teddy

static const CGFloat TDY_BB_X = 5.0f;
static const CGFloat TDY_BB_Y = -5.0f;
static const CGFloat TDY_BB_WIDTH = 30.0f;
static const CGFloat TDY_BB_HEIGHT = 30.0f;

- (id) init
{
	if ((self = [super init])) {
        
        itemType_ = kItemTeddyBear;
        
        boundingBox_ = CGRectMake(TDY_BB_X, TDY_BB_Y, TDY_BB_WIDTH, TDY_BB_HEIGHT);

        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"bird1.png"] retain];
        [self addChild:sprite_ z:-1];    
        
        [super spawnIn];        
    }
    
	return self;
}

- (void) collide {
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bird2.png"];
    [sprite_ setDisplayFrame: frame];
    
    [super collide];
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

@end
