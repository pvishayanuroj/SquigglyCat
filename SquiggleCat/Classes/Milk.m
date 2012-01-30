//
//  Milk.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Milk.h"

@implementation Milk

static const CGFloat MK_BB_X = 0.0f;
static const CGFloat MK_BB_Y = 0.0f;
static const CGFloat MK_BB_WIDTH = 40.0f;
static const CGFloat MK_BB_HEIGHT = 18.0f;

- (id) init 
{
	if ((self = [super init])) {
        
        boundingBox_ = CGRectMake(MK_BB_X, MK_BB_Y, MK_BB_WIDTH, MK_BB_HEIGHT);
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"milk.png"] retain];
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
