//
//  ScoreUtility.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/15/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "ScoreUtility.h"
#import "Score.h"

@implementation ScoreUtility

+ (NSArray *) getLocalScores
{
    NSMutableArray *scores = [NSMutableArray arrayWithCapacity:NUM_HIGH_SCORES];
    NSArray *scoreValues = [[NSUserDefaults standardUserDefaults] arrayForKey:@"High Scores"];
    
    // No scores available
    if (scoreValues == nil) {
        for (int i = 0; i < NUM_HIGH_SCORES; ++i) {
            [scores addObject:[Score score:@"" value:0]];
        }
    }
    // Stores available
    else {
        for (NSNumber *score in scoreValues) {
            [scores addObject:[Score score:@"" value:[score integerValue]]];
        }
    }
    
    return scores;
}

+ (BOOL) checkAndSetLocalScore:(NSInteger)score
{
    NSArray *scoreValues = [[NSUserDefaults standardUserDefaults] arrayForKey:@"High Scores"];
    
    // Get the existing score list, or create an array of zero scores if none exist
    if (scoreValues == nil) {
        NSMutableArray *newScores = [NSMutableArray arrayWithCapacity:NUM_HIGH_SCORES];
        for (int i = 0; i < NUM_HIGH_SCORES; ++i) {
            [newScores addObject:[NSNumber numberWithInteger:0]];
        }
        scoreValues = [NSArray arrayWithArray:newScores];
    }
    
    // Scores are guaranteed to be in sorted order
    BOOL highScoreSet = NO;
    NSNumber *lowestScore = [scoreValues lastObject];
    NSNumber *currentScore = [NSNumber numberWithInteger:score];
    
    // If arg is greater than the receiver
    // Score has broken the lowest high score, save it
    if ([lowestScore compare:currentScore] == NSOrderedAscending) {
        
        highScoreSet = YES;
        NSMutableArray *scores = [NSMutableArray arrayWithArray:scoreValues];
        [scores removeLastObject];
        [scores addObject:currentScore];
        NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];            
        NSArray *sortedScores = [scores sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
        
        NSLog(@"Sorted to store: %@", sortedScores);
        
        [[NSUserDefaults standardUserDefaults] setObject:sortedScores forKey:@"High Scores"];
    }
    
    return highScoreSet;
}

@end
