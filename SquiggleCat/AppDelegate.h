//
//  AppDelegate.h
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright Deloitte 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
