//
//  AnimatedButton.h
//  SquigeeCat
//
//  Created by Dan Boriboon on 28/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AnimatedButton : CCNode <CCTargetedTouchDelegate> {
    
	NSInvocation *invocation_;    
    
    CCSprite *sprite_;
    
    BOOL isLocked_;
    
    BOOL isExpanded_;
    
}

@property (nonatomic, assign) BOOL isLocked;

+ (id) buttonWithImage:(NSString *)imageFile target:(id)target selector:(SEL)selector;

- (id) initButtonWithImage:(NSString *)imageFile target:(id)target selector:(SEL)selector;

- (void) expand;

- (void) unexpand;

@end