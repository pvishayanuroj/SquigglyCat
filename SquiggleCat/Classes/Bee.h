//
//  Bee.h
//  SquiggleCat
//
//  Created by Paul Vishayanuroj on 3/16/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "Item.h"

@interface Bee : Item {
 
    CCAction *animation_;
    
}

- (void) initAnimation;

@end
