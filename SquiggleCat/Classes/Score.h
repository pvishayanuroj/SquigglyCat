//
//  Score.h
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/10/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject {
    
    NSString *name_;
    
    NSInteger value_;
    
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger value;

+ (id) score:(NSString *)name value:(NSInteger)value;

- (id) initScore:(NSString *)name value:(NSInteger)value;

@end
