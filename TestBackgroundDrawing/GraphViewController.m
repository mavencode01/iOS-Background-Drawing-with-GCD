//
//  GraphViewController.m
//  TestBackgroundDrawing
//
//  Created by Bartel, Charles on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "AppDelegate.h"

@interface GraphViewController () {

@private
    BOOL _background;
}

@end

@implementation GraphViewController

- (id)initWithValue:(BOOL)background {
    
    self = [super init];
    if (self) {
        _background = background;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size = [AppDelegate sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
    CGRect navframe = [[self.navigationController navigationBar] frame];
    int height = size.height - navframe.size.height;
    int count = 4;
    
    // Add the GraphViews to this view
    for (int i = 0; i < count; i++) {
        CGRect rect = CGRectMake(0, (float)height/count * i, size.width, (float)height/count);
        GraphView *test = [[[GraphView alloc] initWithFrame:rect] autorelease];
        test.drawInBackGround = _background;
        test.startIndex = arc4random_uniform(size.width); // random start index
        [self.view addSubview:test];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // Tell the graphs to start drawing when the view appears
    for (GraphView *view in self.view.subviews) {
        [view updateView];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

// support all orientations except if the iphone is upside down
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

// UIViewController method
// Notifies when rotation begins
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize size = [AppDelegate sizeInOrientation:toInterfaceOrientation];
    CGRect navframe = [[self.navigationController navigationBar] frame];
    int height = size.height - navframe.size.height;
    
    int count = [self.view.subviews count];
    int i = 0;
    
    // Update the graph views based on the new screen size
    for (GraphView *view in self.view.subviews) {
        CGRect rect = CGRectMake(0, (float)height/count * i, size.width, (float)height/count);
        view.frame = rect;
        i++;
    }
}

@end
