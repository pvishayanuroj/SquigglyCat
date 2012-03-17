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
        
        NSInteger randIdx = arc4random() % 3 + 1;
        
        NSString *spriteName = [NSString stringWithFormat:@"fish%d-1.png", randIdx];
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [sprite_ setRotation:arc4random()%4*45];
        [self addChild:sprite_ z:-1];          
        
        [self initFlopAnimation:randIdx];
        [sprite_ runAction:flopAnimation_];        
        
        [super spawnIn];        
    }
    
	return self;
}

- (void) dealloc
{
    [sprite_ release];
    [flopAnimation_ release];
    
    [super dealloc];
}

- (void) initFlopAnimation:(NSUInteger)idx
{
    NSMutableArray *frames = [NSMutableArray array];
    
    for (NSInteger i = 1; i < 4; ++i) {
        NSString *name = [NSString stringWithFormat:@"fish%d-%d.png", idx, i];
        NSLog(@"%@", name);
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:0.2f];
    flopAnimation_ = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:YES]] retain];     
}

@end
