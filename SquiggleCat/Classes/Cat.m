//
//  Cat.m
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "Cat.h"


@implementation Cat

static const CGFloat CAT_BB_X = 8.0f;
static const CGFloat CAT_BB_Y = 0.0f;
static const CGFloat CAT_BB_WIDTH = 40.0f;
static const CGFloat CAT_BB_HEIGHT = 32.0f;

static const CGFloat CAT_BB_TAIL_SPEED = 0.3f;
static const CGFloat CAT_BB_TAIL_ANGLE = 10.0f;

static const CGFloat CAT_VELOCITY = 480.0f/3.0f;

static const CGFloat CAT_MAX_SIZE = 1.3f;
static const CGFloat CAT_GROWTH_RATE = 0.1f;

static const CGFloat CAT_MIN_SIZE = 1.0f;
static const CGFloat CAT_SHRINK_RATE = 0.1f;

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
        [self addChild:spriteBody_ z:-2];
        
        //Face
        spriteEye_ = [[CCSprite spriteWithSpriteFrameName:@"SquigeeFace_idle.png"] retain];
        [self addChild:spriteEye_ z:-1];
        spriteEye_.position = ccp(3.0f, 0.0f);
        
        //Tail
        spriteTail_ = [[CCSprite spriteWithSpriteFrameName:@"SquigeeTails.png"] retain];
        [self addChild:spriteTail_ z:-3];   
        
        [self initAnimations];
        [self runTailAnimation];
    }
    
    return self;
}

- (void) dealloc
{
    [spriteBody_ release];
    [spriteEye_ release];
    [spriteTail_ release];
    [walkAnimation_ release];
    [surprisedAnimation_ release];
    [hurtFaceAnimation_ release];

    [super dealloc];
}

- (void) initAnimations
{
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_walkLeft.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_walkRight.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.2f];
    walkAnimation_ = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:YES]] retain];    
    
    NSMutableArray *surprisedAnimFrames = [NSMutableArray array];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_EarFlap.png"]];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_EarFlap.png"]];
    [surprisedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    CCAnimation *surprisedAnim = [CCAnimation animationWithFrames:surprisedAnimFrames delay:0.2f];
    surprisedAnimation_ = [[CCAnimate actionWithAnimation:surprisedAnim] retain];
    
    NSMutableArray * hurtFaceAnimFrames = [NSMutableArray array];
    [hurtFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace_hurt.png"]];
    CCAnimation *hurtFace = [CCAnimation animationWithFrames:hurtFaceAnimFrames delay:1.0f];
    hurtFaceAnimation_ = [[CCAnimate actionWithAnimation:hurtFace] retain];    
}

- (void) runWalkAction
{
    [spriteBody_ stopAllActions];
    [spriteBody_ runAction:walkAnimation_];
}

- (void) runTailAnimation
{
    id wiggleLeft = [CCRotateBy actionWithDuration:CAT_BB_TAIL_SPEED angle:-CAT_BB_TAIL_ANGLE];
    id wiggleRight = [CCRotateBy actionWithDuration:CAT_BB_TAIL_SPEED angle:CAT_BB_TAIL_ANGLE];
    id repeat = [CCRepeatForever actionWithAction:[CCSequence actions:wiggleLeft, wiggleRight, nil]];
    [spriteTail_ runAction:repeat];    
}

- (void) walkTo:(CGPoint)pos
{
    CGFloat velocity = CAT_VELOCITY;
    CGPoint delta = ccpSub(pos, self.position);
    CGFloat distance = ccpLength(delta);
    CGFloat moveDuration = distance / velocity;
    
    // Make sure sprite faces the correct direction
    spriteBody_.scaleX = delta.x < 0 ? -1 : 1;    
    spriteEye_.scaleX = delta.x < 0 ? -1 : 1;
    spriteTail_.scaleX = delta.x < 0 ? -1 : 1;
    boundingBox_.origin.x = delta.x < 0 ? -CAT_BB_X : CAT_BB_X;
    
    id move = [CCMoveTo actionWithDuration:moveDuration position:pos];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(doneWalking)];
    [self runAction:[CCSequence actions:move, done, nil]];    
    [self runWalkAction];
}

- (void) doneWalking
{
    [spriteBody_ stopAllActions];
}

- (void) fatten
{
    self.scale += CAT_GROWTH_RATE;    
    if (self.scale > CAT_MAX_SIZE) {
        self.scale = CAT_MAX_SIZE;
    }
}

- (void) slim
{
    self.scale -= CAT_SHRINK_RATE;
    if (self.scale < CAT_MIN_SIZE) {
        self.scale = CAT_MIN_SIZE;
    }
}

- (CGRect) boundingBoxInWorldCoord
{
    return CGRectMake(self.position.x + boundingBox_.origin.x, self.position.y + boundingBox_.origin.y, boundingBox_.size.width * self.scale, boundingBox_.size.height * self.scale);
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
