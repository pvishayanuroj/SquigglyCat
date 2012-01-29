//
//  DataManager.h
//  SquigeeCat
//
//  Created by Dan Boriboon on 28/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject {
	int highscore;
	int gameFlag;		
	
}
@property (readwrite) int highscore;
@property (readwrite) int gameFlag;

+ (DataManager *) sharedManager;

@end