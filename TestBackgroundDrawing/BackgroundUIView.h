//
//  BackgroundUIView.h
//  TestBackgroundDrawing
//
//  Created by Bartel, Charles on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundUIView : UIView

- (void)updateView;

@property (assign, nonatomic, readwrite) BOOL isBusy;
@property (assign, nonatomic, readwrite) BOOL drawInBackGround;

@end
