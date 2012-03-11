//
//  Banners.m
//  SquiggleCat
//
//  Created by Dan Boriboon on 11/3/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "Banners.h"


@implementation Banners

+ (id) banner
{
    return [[[self alloc] initBanner] autorelease];
}

- (id) initBanner
{
    if ((self = [super init])) {
        
        
        //Add Combo Banner
        banner_Combo_ = [[CCSprite spriteWithFile:@"Combo-banner.png"] retain];
        [self addChild:banner_Combo_];
        
        banner_Milky_ = [[CCSprite spriteWithFile:@"MilkyTime-banner.png"] retain];
        [self addChild:banner_Milky_];
        
    }
    
    return self;
}


- (void) dealloc
{
    [banner_Milky_ release];
    [banner_Combo_ release];
    
    [super dealloc];
}

- (void) runSlideIn {
    id JumpIn = [CCJumpBy actionWithDuration:0.5 position:ccp(300,0) height:30 jumps:2];
    id Pause = [CCMoveBy actionWithDuration:0.5 position:ccp(0,0)];
    id JumpOut = [CCJumpBy actionWithDuration:0.5 position:ccp(-300,0) height:30 jumps:2];
    
    id sequence = [CCSequence actions:JumpIn, Pause, JumpOut, nil];
    
    [banner_Milky_ runAction:sequence];
    
}

@end
