//
//  AnimatedButton.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 28/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimatedButton.h"

@implementation AnimatedButton

@synthesize isLocked = isLocked_;

+ (id) buttonWithImage:(NSString *)imageFile target:(id)target selector:(SEL)selector
{
    return [[[self alloc] initButtonWithImage:imageFile target:target selector:selector] autorelease];
}

- (id) initButtonWithImage:(NSString *)imageFile target:(id)target selector:(SEL)selector
{
    if ((self = [super init])) {
        
		NSMethodSignature * sig = nil;
		
		if (target && selector) {
			sig = [target methodSignatureForSelector:selector];
			
			invocation_ = nil;
			invocation_ = [NSInvocation invocationWithMethodSignature:sig];
			[invocation_ setTarget:target];
			[invocation_ setSelector:selector];
			[invocation_ retain];
		}        
        
        sprite_ = [[CCSprite spriteWithFile:imageFile] retain];
        [self addChild:sprite_];
        isExpanded_ = NO;
        isLocked_ = NO;
        
    }
    return self;
}

- (void) dealloc
{
    [invocation_ release];
    [sprite_ release];
    
    [super dealloc];
}

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{
	CGRect r = sprite_.textureRect;	
	r = CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);	
	
	return CGRectContainsPoint(r, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (![self containsTouchLocation:touch] || isLocked_)
		return NO;
    
    [self expand];
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Moved onto the button
	if ([self containsTouchLocation:touch]) {
        if (!isExpanded_) {
            [self expand];
        }
    }
    // Moved off of the button
    else {
        if (isExpanded_) {
            [self unexpand];
        }
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self unexpand];
	if ([self containsTouchLocation:touch]) {
        [invocation_ invoke];
    }
}

- (void) expand
{
    sprite_.scale = 1.05f;
    isExpanded_ = YES;
}

- (void) unexpand
{
    sprite_.scale = 1.0f;
    isExpanded_ = NO;
}


@end