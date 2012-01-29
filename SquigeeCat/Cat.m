//
//  Cat.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 22/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Cat.h"


@implementation Cat
@synthesize state, sprite_;
@synthesize rect = rect_;

- (id)initWithPosition:(CGPoint)pos {
	if((self = [super init])){
        
        //Define Collision Box
        rect_.origin = CGPointMake(8, 0);
        rect_.size.height = 32;
        rect_.size.width = 40;
        
        //Load Sprite
        //Body
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Squigee_normal.png"]retain];
        [self addChild:sprite_ z:10];
        //Face
        spriteEye_ = [[CCSprite spriteWithSpriteFrameName:@"SquigeeFace_idle.png"]retain];
        [self addChild:spriteEye_ z:11];
        [spriteEye_ setPosition:ccp(3,0)];
        //Tail
        spriteTail_ = [[CCSprite spriteWithSpriteFrameName:@"SquigeeTails.png"]retain];
        [self addChild:spriteTail_ z:9];   
        
        self.position = pos;
		self.state = kCatStateIdle;  
        
        id wiggleLeft = [CCRotateBy actionWithDuration:0.3 angle:-10];
        id wiggleRight = [CCRotateBy actionWithDuration:0.3 angle:10];
        id repeat = [CCRepeatForever actionWithAction:[CCSequence actions:wiggleLeft, wiggleRight, nil]];
        [spriteTail_ runAction:repeat];
        
    }
	return self;
}

- (void)walk {
    NSLog(@"walking");
    
    // Load up walking animation frames
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_walkLeft.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_walkRight.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.2f];
    walkAnimation_ = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:YES]];
    [sprite_ runAction:walkAnimation_];
    [spriteEye_ setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace_idle.png"]];

}

- (void)surprised {
    NSLog(@"surprised");
    // Load up surprised animation frames
    NSMutableArray *surprisedAnimFrames = [NSMutableArray array];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_EarFlap.png"]];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_EarFlap.png"]];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    CCAnimation *surprisedAnim = [CCAnimation animationWithFrames:surprisedAnimFrames delay:0.2f];
    surprisedAnimation_ = [CCAnimate actionWithAnimation:surprisedAnim];
    [sprite_ runAction:surprisedAnimation_];
    
    NSMutableArray * hurtFaceAnimFrames = [NSMutableArray array];
    [hurtFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace_hurt.png"]];
    CCAnimation *hurtFace = [CCAnimation animationWithFrames:hurtFaceAnimFrames delay:1.0f];
    hurtFaceAnimation_ = [CCAnimate actionWithAnimation:hurtFace];
    [spriteEye_ runAction:hurtFaceAnimation_];
    
}


- (void) dealloc
{
    [sprite_ release];
    [super dealloc];
}


#if DEBUG_BOUNDINGBOX
- (void) draw
{
    // top left
    CGPoint p1 = ccp(rect_.origin.x - rect_.size.width / 2, rect_.origin.y + rect_.size.height / 2);
    // top right
    CGPoint p2 = ccp(rect_.origin.x + rect_.size.width / 2, rect_.origin.y + rect_.size.height / 2);
    // bottom left
    CGPoint p3 = ccp(rect_.origin.x - rect_.size.width / 2, rect_.origin.y - rect_.size.height / 2);
    // bottom right
    CGPoint p4 = ccp(rect_.origin.x + rect_.size.width / 2, rect_.origin.y - rect_.size.height / 2);    
    
    glColor4f(1.0, 0, 0, 1.0);            
    ccDrawLine(p1, p2);
    ccDrawLine(p3, p4);    
    ccDrawLine(p2, p4);
    ccDrawLine(p1, p3);    
}
#endif
@end
