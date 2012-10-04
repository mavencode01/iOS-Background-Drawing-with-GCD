//
//  AppDelegate.h
//  TestBackgroundDrawing
//
//  Created by Bartel, Charles on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;
+(CGRect)rectInOrientation:(UIInterfaceOrientation)orientation;

@property (strong, nonatomic) UIWindow *window;

@end
