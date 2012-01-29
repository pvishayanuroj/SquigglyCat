//
//  GameObjects.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 22/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObjects.h"

@implementation GameObjects
@synthesize isHit, isOktoRemove, gridLocX, gridLocY;

-(id) init
{   
    
	if( (self=[super init])) {
        
        // sprite sheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spritesheet.plist"];
		spriteSheet = [[CCSpriteBatchNode alloc] initWithFile:@"spritesheet.png" capacity:50];
		[self addChild:spriteSheet];
        
	}
	return self;
}


- (CGRect) Rect 
{
	return CGRectMake (self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);	
}


@end
