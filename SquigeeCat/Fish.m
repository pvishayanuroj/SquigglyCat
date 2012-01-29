//
//  Fish.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 23/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Fish.h"


@implementation Fish

- (id)initWithPosition:(CGPoint)pos {
	if((self = [super init])){
        
        //Define Collision Box
        rect_.origin = CGPointMake(0, 0);
        rect_.size.height = 28;
        rect_.size.width = 16;
        
        
        //Load Sprite
        //Body
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"fish1.png"]retain];

        
        [self addChild:sprite_ z:5];
        
        self.position = pos;
        
        
        
    }
	return self;
}

@end
