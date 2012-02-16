//
//  ScoreUtility.h
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/15/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>

@interface ScoreUtility : NSObject {
    
}

+ (NSArray *) getLocalScores;

+ (BOOL) checkAndSetLocalScore:(NSInteger)score;

@end
