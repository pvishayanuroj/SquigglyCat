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
    
    CCLabelBMFont *text_;
    
}

@property (nonatomic, assign) NSInteger score;

+ (id) incrementingText;

- (id) initIncrementingText;

- (void) updateTextScore:(NSInteger)score;

@end
