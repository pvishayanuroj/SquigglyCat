//
//  TrashCan.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TrashCan.h"


@implementation TrashCan
- (id)initWithPosition:(CGPoint)pos {
	if((self = [super init])){
        
        //Define Collision Box
        rect_.origin = CGPointMake(0, 0);
        rect_.size.height = 60;
        rect_.size.width = 40;
        
        
        //Load Sprite
        //Body
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"trashcan1.png"]retain];        
        [self addChild:sprite_ z:5];
        
        self.position = pos;
        
        
        
    }
	return self;
}

-(void)crash {
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"trashcan2.png"];
    [sprite_ setDisplayFrame: frame];
    NSLog(@"hitTrash");
    [self spawnOut];
}

@end
