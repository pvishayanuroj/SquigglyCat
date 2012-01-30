//
//  Fish.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 23/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Fish.h"


@implementation Fish

static const CGFloat FS_BB_X = 0.0f;
static const CGFloat FS_BB_Y = 0.0f;
static const CGFloat FS_BB_WIDTH = 16.0f;
static const CGFloat FS_BB_HEIGHT = 28.0f;

- (id) init 
{
	if ((self = [super init])) {
        
        boundingBox_ = CGRectMake(FS_BB_X, FS_BB_Y, FS_BB_WIDTH, FS_BB_HEIGHT);
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"fish1.png"] retain];
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
