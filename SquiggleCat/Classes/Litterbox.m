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
static const CGFloat LB_BB_WIDTH = 50.0f;
static const CGFloat LB_BB_HEIGHT = 25.0f;

- (id) init 
{
	if ((self = [super init])) {
        
        itemType_ = kItemLitterBox;
        
        boundingBox_ = CGRectMake(LB_BB_X, LB_BB_Y, LB_BB_WIDTH, LB_BB_HEIGHT);
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"litterbox.png"] retain];
        [self addChild:sprite_ z:-1];
        
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
