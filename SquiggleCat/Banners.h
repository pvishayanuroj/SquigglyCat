//
//  Banners.h
//  SquiggleCat
//
//  Created by Dan Boriboon on 11/3/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Banners : CCNode {
        CCSprite *banner_Combo_;
        CCSprite *banner_Milky_;
    
}
+ (id) banner;
- (id) initBanner;
- (void) runSlideIn;
@end
