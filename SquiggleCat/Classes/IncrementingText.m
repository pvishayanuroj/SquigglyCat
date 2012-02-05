//
//  IncrementingText.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 1/30/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "IncrementingText.h"


@implementation IncrementingText

const static CGFloat IT_UPDATE_TIME = 1.0f/60.0f;
const static NSInteger IT_INCREMENT_AMOUNT = 4;

@synthesize score = score_;

+ (id) incrementingText
{
    return [[[self alloc] initIncrementingText] autorelease];
}

- (id) initIncrementingText
{
    if ((self = [super init])) {
        
        actualScore_ = 0;
        score_ = 0;
        NSString *scoreText = [NSString stringWithFormat:@"%d", score_];
        text_ = [[CCLabelBMFont labelWithString:scoreText fntFile:@"SquigglyWhite.fnt"] retain];
        
        text_.anchorPoint = CGPointMake(0, 0.5f);
        [self addChild:text_];
        
        [self schedule:@selector(updateLoop:) interval:IT_UPDATE_TIME];
    }
    return self;
}

- (void) dealloc
{
    [text_ release];
    
    [super dealloc];
}

- (void) updateLoop:(ccTime)dt
{
    if (actualScore_ < score_) {
        actualScore_ += IT_INCREMENT_AMOUNT;
        if (actualScore_ > score_) {
            actualScore_ = score_;
        }
        [self updateTextScore:actualScore_];        
    }
    else if (actualScore_ > score_) {
        actualScore_ -= IT_INCREMENT_AMOUNT;
        if (actualScore_ < score_) {
            actualScore_ = score_;
        }
        [self updateTextScore:actualScore_];
    }
}

- (void) updateTextScore:(NSInteger)score
{
    NSString *scoreText = [NSString stringWithFormat:@"%d", score];    
    [text_ setString:scoreText];
}

@end
