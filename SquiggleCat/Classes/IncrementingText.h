//
//  IncrementingText.h
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 1/30/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface IncrementingText : CCNode {
    
    NSInteger actualScore_;
    
    NSInteger score_;
    
}

@property (nonatomic, readonly) NSInteger score;

+ (id) incrementingText;

- (id) initIncrementingText;

- (void) setScore:(NSInteger)score;

@end
