//
//  Litterbox.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Litterbox.h"


@implementation Litterbox

static const CGFloat LB_BB_X = 0.0f;
static const CGFloat LB_BB_Y = 0.0f;
static const CGFloat LB_BB_WIDTH = 20.0f;
static const CGFloat LB_BB_HEIGHT = 10.0f;

- (id) init 
{
	if ((self = [super init])) {
        
        boundingBox_ = CGRectMake(LB_BB_X, LB_BB_Y, LB_BB_WIDTH, LB_BB_HEIGHT);
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"litterbox.png"] retain];
        [self addChild:sprite_];
        
        [super spawnIn];        
    }
    
	return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

@end
