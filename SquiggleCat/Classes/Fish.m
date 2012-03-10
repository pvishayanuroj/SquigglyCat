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

        itemType_ = kItemFish;        
        
        boundingBox_ = CGRectMake(FS_BB_X, FS_BB_Y, FS_BB_WIDTH, FS_BB_HEIGHT);
        int x = rand()%6+1;        
        switch (x) {
            case 1:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"fish1-1.png"] retain];
                break;
            case 2:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"fish2-1.png"] retain];
                break;
            case 3:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"fish3-1.png"] retain];
                break;
            case 4:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"fish1-3.png"] retain];
                break;
            case 5:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"fish2-3.png"] retain];
                break;
            case 6:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"fish3-3.png"] retain];
                break;
            default:
                break;
        }
        [sprite_ setRotation:rand()%4*45];
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
