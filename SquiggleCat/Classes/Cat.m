//
//  Cat.m
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "Cat.h"


@implementation Cat

static const CGFloat CAT_BB_X = 0.0f;
static const CGFloat CAT_BB_Y = 0.0f;
static const CGFloat CAT_BB_WIDTH = 40.0f;
static const CGFloat CAT_BB_HEIGHT = 32.0f;

static const CGFloat CAT_BB_TAIL_SPEED = 0.3f;
static const CGFloat CAT_BB_TAIL_ANGLE = 10.0f;

@synthesize boundingBox = boundingBox_;

+ (id) cat
{
    return [[[self alloc] initCat] autorelease];
}

- (id) initCat
{
    if ((self = [super init])) {
        
        //Define Collision Box
        boundingBox_ = CGRectMake(CAT_BB_X, CAT_BB_Y, CAT_BB_WIDTH, CAT_BB_HEIGHT);
        
        //Body
        spriteBody_ = [[CCSprite spriteWithSpriteFrameName:@"Squigee_normal.png"] retain];
        [self addChild:spriteBody_ z:1];
        
        //Face
        spriteEye_ = [[CCSprite spriteWithSpriteFrameName:@"SquigeeFace_idle.png"] retain];
        [self addChild:spriteEye_ z:2];
        spriteEye_.position = ccp(3.0f, 0.0f);
        
        //Tail
        spriteTail_ = [[CCSprite spriteWithSpriteFrameName:@"SquigeeTails.png"] retain];
        [self addChild:spriteTail_ z:0];   
    }
    
    return self;
}

- (void) dealloc
{
    [spriteBody_ release];
    [spriteEye_ release];
    [spriteTail_ release];

    [super dealloc];
}

- (void) initTailAnimation
{
    id wiggleLeft = [CCRotateBy actionWithDuration:CAT_BB_TAIL_SPEED angle:-CAT_BB_TAIL_ANGLE];
    id wiggleRight = [CCRotateBy actionWithDuration:CAT_BB_TAIL_SPEED angle:CAT_BB_TAIL_ANGLE];
    id repeat = [CCRepeatForever actionWithAction:[CCSequence actions:wiggleLeft, wiggleRight, nil]];
    [spriteTail_ runAction:repeat];    
}

- (CGRect) boundingBoxInWorldCoord
{
    return CGRectMake(self.position.x + boundingBox_.origin.x, self.position.y + boundingBox_.origin.y, boundingBox_.size.width, boundingBox_.size.height);
}

#if DEBUG_BOUNDINGBOX
- (void) draw
{
    // top left
    CGPoint p1 = ccp(boundingBox_.origin.x - boundingBox_.size.width / 2, boundingBox_.origin.y + boundingBox_.size.height / 2);
    // top right
    CGPoint p2 = ccp(boundingBox_.origin.x + boundingBox_.size.width / 2, boundingBox_.origin.y + boundingBox_.size.height / 2);
    // bottom left
    CGPoint p3 = ccp(boundingBox_.origin.x - boundingBox_.size.width / 2, boundingBox_.origin.y - boundingBox_.size.height / 2);
    // bottom right
    CGPoint p4 = ccp(boundingBox_.origin.x + boundingBox_.size.width / 2, boundingBox_.origin.y - boundingBox_.size.height / 2);    
    
    glColor4f(1.0, 0, 0, 1.0);            
    ccDrawLine(p1, p2);
    ccDrawLine(p3, p4);    
    ccDrawLine(p2, p4);
    ccDrawLine(p1, p3);    
}
#endif

@end
