//
//  Milk.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Milk.h"


@implementation Milk

- (id)initWithPosition:(CGPoint)pos {
	if((self = [super init])){
        
        //Define Collision Box
        rect_.origin = CGPointMake(0, 0);
        rect_.size.height = 18;
        rect_.size.width = 40;
        
        
        //Load Sprite
        //Body
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"milk.png"]retain];
        
        
        [self addChild:sprite_ z:5];
        
        self.position = pos;
        
        
        
    }
	return self;
}

@end
