//
//  Score.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/10/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "Score.h"

@implementation Score

@synthesize name = name_;
@synthesize value = value_;

+ (id) score:(NSString *)name value:(NSInteger)value
{
    return [[[self alloc] initScore:name value:value] autorelease];
}

- (id) initScore:(NSString *)name value:(NSInteger)value
{
    if ((self = [super init])) {
     
        name_ = [[NSString stringWithString:name] retain];
        value_ = value;
    }
    return self;
}

- (void) dealloc
{
    [name_ release];
    
    [super dealloc];
}

- (NSComparisonResult) compare:(Score *)otherScore 
{
    if (self.value == otherScore.value) {
        return [self.name compare:otherScore.name];
    }
    return self.value < otherScore.value;
}

@end
