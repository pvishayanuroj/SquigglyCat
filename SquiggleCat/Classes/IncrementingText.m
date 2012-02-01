//
//  IncrementingText.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 1/30/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "IncrementingText.h"


@implementation IncrementingText

@synthesize score = score_;

+ (id) incrementingText
{
    return [[[self alloc] initIncrementingText] autorelease];
}

- (id) initIncrementingText
{
    if ((self = [super init])) {
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) setScore:(NSInteger)score
{
    
}

@end
