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
static const CGFloat CAT_VELOCITY_INCREASE = 20.0f;

static const CGFloat CAT_MAX_SIZE = 1.3f;
static const CGFloat CAT_GROWTH_RATE = 0.1f;

static const CGFloat CAT_MIN_SIZE = 1.0f;
static const CGFloat CAT_SHRINK_RATE = 0.1f;

static const CGFloat INIT_COMBO_COUNTER = 0.0f; //Initializing the Counter
static const CGFloat MILKY_TIME_COMBO_TRIGGER = 2.0f; //How much Milk to trigger MilkyTime
static const CGFloat MAX_MILKY_TIME_METER = 3.0f;  //How long Milky Time lasts


@synthesize boundingBox = boundingBox_;
@synthesize moveTarget = moveTarget_;
@synthesize milkyTimeMeter_;

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
        spriteBody_ = [[CCSprite spriteWithSpriteFrameName:@"Squiggy-Body-Idle.png"] retain];
        [self addChild:spriteBody_ z:-2];
        
        //Face
        spriteEye_ = [[CCSprite spriteWithSpriteFrameName:@"Squiggy-Face-Idle.png"] retain];
        [self addChild:spriteEye_ z:-1];
        spriteEye_.position = ccp(3.0f, 0.0f);
        
        //Tail
        spriteTail_ = [[CCSprite spriteWithSpriteFrameName:@"Squiggy-Tail.png"] retain];
        [self addChild:spriteTail_ z:-3];   
        
        [self initAnimations];
        [self runTailAnimation];
        [self catBreathing];
        
        currentMoveAction_ = nil;
        velocity_ = CAT_VELOCITY;
        milkCombo_ = INIT_COMBO_COUNTER;
        bonusComboMeter_ = INIT_COMBO_COUNTER;
        milkyTimeMeter_ = 0; // 0 - Flag Off; 1 - Flag On.
        
        //Particle
        particle_= [[CCParticleSystemQuad alloc] initWithTotalParticles:100];
        
        CCTexture2D *texture=[[CCTextureCache sharedTextureCache] addImage:@"squigParticle.png"];
        particle_.texture=texture;
        particle_.emissionRate=50;
        particle_.angle=10.0;
        particle_.angleVar=360.0;
        particle_.duration =-1.00;
        particle_.emitterMode=kCCParticleModeGravity;
        ccColor4F startColor={1.00,0.60,0.30,1.00};
        particle_.startColor=startColor;
        ccColor4F endColor={0.60,0.90,0.20,0.80};
        ccColor4F startColorVar = {0.00, 0.00, 0.00, 1.00};
        ccColor4F endColorVar = {0.00, 0.00, 0.00, 0.00};
        particle_.endColor=endColor;
        particle_.startColorVar=startColorVar;
        particle_.endColorVar=endColorVar;
        particle_.startSize=40.00;
        particle_.endSize=2.00;
        particle_.startSizeVar=10.00;
        particle_.endSizeVar=10.00;
        particle_.gravity=ccp(0,50);
        particle_.radialAccel=-120.00;
        particle_.speed=80;
        particle_.life=0.00;
        [self addChild:particle_ z:-4];
        [self runHappyAnimation];

        
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
    [hurtFaceAnimation_ release];
    [happyFaceAnimation_ release];
    [surprisedFaceAnimation_ release];
    [yummyFaceAnimation_ release];
    [poopFaceAnimation_ release];
    [currentMoveAction_ release];    
    [particle_ release];

    [super dealloc];
}

- (void) initAnimations
{
    //*******Body Animations*******//
    //Walking Animation
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Body-Left.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Body-Right.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Body-Idle.png"]];
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.2f];
    walkAnimation_ = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:YES]] retain];    
        
    //*******Facial Animations*******//
    //Hurt
    NSMutableArray *hurtFaceAnimFrames = [NSMutableArray array];
    [hurtFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-hurt.png"]];
    CCAnimation *hurtFace = [CCAnimation animationWithFrames:hurtFaceAnimFrames delay:1.0f];
    hurtFaceAnimation_ = [[CCAnimate actionWithAnimation:hurtFace] retain];    
    
    //Happy
    NSMutableArray *happyFaceAnimFrames = [NSMutableArray array];
    [happyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-happy.png"]];
    CCAnimation *happyFace = [CCAnimation animationWithFrames:happyFaceAnimFrames delay:1.0f];
    happyFaceAnimation_ = [[CCAnimate actionWithAnimation:happyFace] retain];
    
    //Surprised
    NSMutableArray *surprisedFaceAnimFrames = [NSMutableArray array];
    [surprisedFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-shocked.png"]];
    CCAnimation *surprisedFace = [CCAnimation animationWithFrames:surprisedFaceAnimFrames delay:1.0f];
    surprisedFaceAnimation_ = [[CCAnimate actionWithAnimation:surprisedFace] retain]; 
    
    //Poop Face
    NSMutableArray *poopFaceAnimFrames = [NSMutableArray array];
    [poopFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-poop.png"]];
    CCAnimation *poopFace = [CCAnimation animationWithFrames:poopFaceAnimFrames delay:1.0f];
    poopFaceAnimation_ = [[CCAnimate actionWithAnimation:poopFace] retain];     
    
    
    //Dizzy
    NSMutableArray *dizzyFaceAnimFrames = [NSMutableArray array];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-dizzy1.png"]];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-dizzy2.png"]];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-dizzy1.png"]];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-dizzy2.png"]];
    [dizzyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-dizzy1.png"]];
    CCAnimation *dizzyFace = [CCAnimation animationWithFrames:dizzyFaceAnimFrames delay:0.2f];
    dizzyFaceAnimation_ = [[CCAnimate actionWithAnimation:dizzyFace] retain]; 
    
    //Eating-Yummy
    NSMutableArray *yummyFaceAnimFrames = [NSMutableArray array];
    [yummyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-yummy1.png"]];
    [yummyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-yummy2.png"]];
    [yummyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-yummy1.png"]];
    [yummyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-yummy2.png"]];
    [yummyFaceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Squiggy-Face-yummy1.png"]];
    CCAnimation *yummyFace = [CCAnimation animationWithFrames:yummyFaceAnimFrames delay:0.2f];
    yummyFaceAnimation_ = [[CCAnimate actionWithAnimation:yummyFace] retain]; 
}

- (void) resetIdleFrame
{
    [spriteEye_ stopAllActions];
    [spriteBody_ stopAllActions];    
    
    NSString *spriteEyeFrameName = [NSString stringWithFormat:@"Squiggy-Face-Idle.png"];
    [spriteEye_ setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteEyeFrameName]];
    
    NSString *spriteBodyFrameName = [NSString stringWithFormat:@"Squiggy-Body-Idle.png"];
    [spriteBody_ setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteBodyFrameName]];    
}

- (void) runHurtAnimation
{
    [spriteBody_ stopAllActions];
    [spriteEye_ stopAllActions];
    [spriteEye_ runAction:hurtFaceAnimation_];    
}

- (void) doneHurt
{
    [spriteEye_ stopAllActions];        
}

- (void) runHappyAnimation
{
    [spriteEye_ stopAllActions];
    [spriteBody_ stopAllActions];
    [spriteEye_ runAction:happyFaceAnimation_];  
    
    // Ensure that delay is equal to animation time
    id delay = [CCDelayTime actionWithDuration:1.0f];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(resetIdleFrame)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) runSurprisedAnimation
{
    [spriteEye_ stopAllActions];
    [spriteBody_ stopAllActions];
    [spriteEye_ runAction:surprisedFaceAnimation_];    
    
    // Ensure that delay is equal to animation time
    id delay = [CCDelayTime actionWithDuration:1.0f];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(resetIdleFrame)];
    [self runAction:[CCSequence actions:delay, done, nil]];    
}

- (void) runDizzyAnimation
{
    [spriteEye_ stopAllActions];
    [spriteBody_ stopAllActions];
    [spriteEye_ runAction:dizzyFaceAnimation_];    
    
    // Ensure that delay is equal to animation time
    id delay = [CCDelayTime actionWithDuration:1.0f];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(resetIdleFrame)];
    [self runAction:[CCSequence actions:delay, done, nil]]; 
    
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundBirdChirps];
}

- (void) runEatingAnimation
{
    [spriteEye_ stopAllActions];
    [spriteBody_ stopAllActions];
    [spriteEye_ runAction:yummyFaceAnimation_];    
    
    // Ensure that delay is equal to animation time
    id delay = [CCDelayTime actionWithDuration:1.0f];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(resetIdleFrame)];
    [self runAction:[CCSequence actions:delay, done, nil]];    
}

- (void) runPoopAnimation
{
    [spriteEye_ stopAllActions];
    [spriteBody_ stopAllActions];
    [spriteEye_ runAction:poopFaceAnimation_];    
    
    // Ensure that delay is equal to animation time
    id delay = [CCDelayTime actionWithDuration:1.0f];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(resetIdleFrame)];
    [self runAction:[CCSequence actions:delay, done, nil]];    
}

- (void) runJumpAnimation
{
    [self runAction:[CCJumpBy actionWithDuration:0.5f position:ccp(0,0) height:20 jumps:1]];
}

- (void) startMilkyTime
{
    particle_.life = 1;
    milkyTimeMeter_ = MAX_MILKY_TIME_METER;
}

- (void) endMilkyTime
{
    milkyTimeMeter_ = 0; //reset Milky Time Meter
    particle_.life = 0;
}

- (void) runWalkAction
{
    [spriteEye_ stopAllActions];
    [spriteBody_ stopAllActions];
    [spriteBody_ runAction:walkAnimation_];
}

- (void) doneWalking
{
    [spriteBody_ stopAllActions];
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

- (void) catCollide:(ItemType)itemType
{
    switch (itemType) {
        // Fish fattens cat and makes it happy
        case kItemFish:
            [self fatten];
            [self runEatingAnimation];
            [[SimpleAudioEngine sharedEngine] playEffect:kSoundPoints];
            bonusComboMeter_++;
            break;
        // Milk speeds up the cat and makes it happy
        case kItemMilk:
            if(milkCombo_ >= MILKY_TIME_COMBO_TRIGGER){
                [self runJumpAnimation];
                [self startMilkyTime];
                [[SimpleAudioEngine sharedEngine] playEffect:kSoundSquiggy];
                milkCombo_ = 0.0f; //reset combo meter
            }
            else {
                [[SimpleAudioEngine sharedEngine] playEffect:kSoundSlurp];
                velocity_ += CAT_VELOCITY_INCREASE;
                [self runEatingAnimation];  
                milkCombo_++; //increase combo meter
            }
            break;
        // Trash can runs hurt animation, freezes cat
        case kItemTrashCan:
            if(milkyTimeMeter_<1){
                [self stopAllActions];
                [self runDizzyAnimation];
            }
            [[SimpleAudioEngine sharedEngine] playEffect:kSoundBump];
            break;
        // Litter box resets cat velocity, slims it down, and makes it happy
        case kItemLitterBox:
            velocity_ = CAT_VELOCITY;
            [self slim];
            [self runPoopAnimation];
            [[SimpleAudioEngine sharedEngine] playEffect:kSoundLitterbox];
            break;
        // Teddy bear runs surprised animation
        case kItemTeddyBear:
            if(milkyTimeMeter_ < 1){
                [self stopAllActions];            
                [self runHurtAnimation];
                [[SimpleAudioEngine sharedEngine] playEffect:kSoundBirdSquawk];
            }
            break;
        case kItemBee:
            if(milkyTimeMeter_ < 1) {
                [self stopAllActions];            
                [self runHurtAnimation];
                //[[SimpleAudioEngine sharedEngine] playEffect:kSoundBirdSquawk];
            }
            break;
        default:
            break;
    }
}

- (void) walkTo:(CGPoint)pos
{
    CGPoint delta = ccpSub(pos, self.position);
    CGFloat distance = ccpLength(delta);
    CGFloat moveDuration = distance / velocity_;
    
    // Make sure sprite faces the correct direction
    spriteBody_.scaleX = delta.x < 0 ? -1 : 1;    
    spriteEye_.scaleX = delta.x < 0 ? -1 : 1;
    spriteTail_.scaleX = delta.x < 0 ? -1 : 1;
    boundingBox_.origin.x = delta.x < 0 ? -CAT_BB_X : CAT_BB_X;
    
    id move = [CCMoveTo actionWithDuration:moveDuration position:pos];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(doneWalking)];
    if (currentMoveAction_) {
        [self stopAction:currentMoveAction_];
    }
    [currentMoveAction_ release];
    currentMoveAction_ = [[self runAction:[CCSequence actions:move, done, nil]] retain];   
    [self runWalkAction];
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
