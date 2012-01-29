//
//  Litterbox.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Litterbox.h"


@implementation Litterbox

- (id)initWithPosition:(CGPoint)pos {
	if((self = [super init])){
        
        //Define Collision Box
        rect_.origin = CGPointMake(0, 0);
        rect_.size.height = 10;
        rect_.size.width = 20;
        
        
        //Load Sprite
        //Body
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"litterbox.png"]retain];
        
        
        [self addChild:sprite_ z:5];
        
        self.position = pos;
        
        
        
    }
	return self;
}
@end
