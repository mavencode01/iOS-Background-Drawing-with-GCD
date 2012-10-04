//
//  AppDelegate.h
//  TestBackgroundDrawing
//
//  Created by Bartel, Charles on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// This app shows how to use GCD to do custom drawing in a background thread
// This is helpful when the custom drawing is processor intensive and is causing the UI thread to become nonresponsive
// BackgroudUIView is the base class that provides the GCD functionality
// The BackgroudUIView subclasses should override drawWithContext: and do the custom drawing there
// The app supports multiple orientations and updates after orientation changes
// The app is universal so it supports the ipad and iphone
// For this example the user is presented with two options: draw in the background or on the main UI thread
// The back button will remain responsive if the user picks the background option

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Returns the size of the screen based on the passed in screen orientation
+(CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;

// Returns a rect of the screen based on the passed in screen orientation
+(CGRect)rectInOrientation:(UIInterfaceOrientation)orientation;

@property (strong, nonatomic) UIWindow *window;

@end
