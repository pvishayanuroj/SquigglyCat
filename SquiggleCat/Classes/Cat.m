//
//  Cat.m
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "Cat.h"
#import "Utility.h"

@implementation Cat

static const CGFloat CAT_LOOP_SPEED = 1.0f/60.0f;

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
@synthesize moveTarget = moveTarget_;
@synthesize catVelocity;

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
        [self catBreathing];
        
        catVelocity = CAT_VELOCITY;
        
        moveTarget_ = self.position;
        //[self schedule:@selector(moveLoop:) interval:CAT_LOOP_SPEED]; 
        
    }
    
    return self;
}

- (void) dealloc
{
    [spriteBody_ release];
    [spriteEye_ release];
    [spriteTail_ release];
    [walkAnimation_ release];
    [earFlapAnimation_ release];
    [hurtFaceAnimation_ release];
    [happyFaceAnimation_ release];
    [surprisedFaceAnimation_ release];

    [super dealloc];
}

- (void) initAnimations
{
    //*******Body Animations*******//
    //Walking Animation
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_walkLeft.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_walkRight.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.2f];
    walkAnimation_ = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:YES]] retain];    
    
    //Earflapping Animation
    NSMutableArray *earFlapAnimFrames = [NSMutableArray array];
    [earFlapAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    [earFlapAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_EarFlap.png"]];
    [earFlapAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    [earFlapAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_EarFlap.png"]];
    [earFlapAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squigee_normal.png"]];
    CCAnimation *earFlapAnim = [CCAnimation animationWithFrames:earFlapAnimFrames delay:0.2f];
    earFlapAnimation_ = [[CCAnimate actionWithAnimation:earFlapAnim] retain];
    
    //*******Facial Animations*******//
    //Hurt
    NSMutableArray *hurtFaceAnimFrames = [NSMutableArray array];
    [hurtFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace_hurt.png"]];
    CCAnimation *hurtFace = [CCAnimation animationWithFrames:hurtFaceAnimFrames delay:1.0f];
    hurtFaceAnimation_ = [[CCAnimate actionWithAnimation:hurtFace] retain];    
    
    //Happy
    NSMutableArray *happyFaceAnimFrames = [NSMutableArray array];
    [happyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace_happy.png"]];
    CCAnimation *happyFace = [CCAnimation animationWithFrames:happyFaceAnimFrames delay:1.0f];
    happyFaceAnimation_ = [[CCAnimate actionWithAnimation:happyFace] retain];
    
    //Surprised
    NSMutableArray *surprisedFaceAnimFrames = [NSMutableArray array];
    [surprisedFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace_surprised.png"]];
    CCAnimation *surprisedFace = [CCAnimation animationWithFrames:surprisedFaceAnimFrames delay:1.0f];
    surprisedFaceAnimation_ = [[CCAnimate actionWithAnimation:surprisedFace] retain]; 
    
    //Dizzy
    NSMutableArray *dizzyFaceAnimFrames = [NSMutableArray array];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace-dizzy1.png"]];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace-dizzy2.png"]];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace-dizzy1.png"]];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace-dizzy2.png"]];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"SquigeeFace-dizzy1.png"]];
    CCAnimation *dizzyFace = [CCAnimation animationWithFrames:dizzyFaceAnimFrames delay:0.2f];
    dizzyFaceAnimation_ = [[CCAnimate actionWithAnimation:dizzyFace] retain]; 
}

- (void) catHurt
{
    [spriteEye_ stopAllActions];
    [spriteEye_ runAction:hurtFaceAnimation_];
}

- (void) catHappy
{
    [spriteEye_ stopAllActions];
    [spriteBody_ stopAllActions];
    [spriteEye_ runAction:happyFaceAnimation_];
    [spriteBody_ runAction:earFlapAnimation_];
}

- (void) catSurprised
{
    [spriteEye_ stopAllActions];    
    [spriteEye_ runAction:surprisedFaceAnimation_];
}

- (void) catDizzy
{
    [spriteEye_ stopAllActions];
    [spriteEye_ runAction:dizzyFaceAnimation_];
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

- (void) catBreathing
{
    id breatheIn = [CCMoveBy actionWithDuration:0.8f position:ccp(0,3)];
    id breatheOut = [CCMoveBy actionWithDuration:1.2f position:ccp(0,-3)];
    id repeat = [CCRepeatForever actionWithAction:[CCSequence actions:breatheIn, breatheOut, nil]];
    [spriteEye_ runAction:repeat];
}

- (void) walkTo:(CGPoint)pos
{
    CGFloat velocity = catVelocity;
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

- (void) moveLoop:(ccTime)dt
{
    [self moveTowards:moveTarget_];
}

- (void) moveTowards:(CGPoint)pos
{
    if (![Utility pointsEqual:pos b:self.position]) {
        
        CGFloat magnitude = [Utility euclieanDistance:pos b:self.position];
        
        if (magnitude == 0) {
            return;
        }
        magnitude /= 15.0f;
        
        CGPoint delta = ccpSub(pos, self.position);
        delta.x /= magnitude;
        delta.y /= magnitude;
        
        //NSLog(@"mag: %4.2f", magnitude);
        //DebugPoint(@"delta", delta);
        
        self.position = ccpAdd(self.position, delta);        
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
