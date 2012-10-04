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
    for (int i = 0; i < count; i++) {
        CGRect rect = CGRectMake(0, (float)height/count * i, size.width, (float)height/count);
        GraphView *test = [[[GraphView alloc] initWithFrame:rect] autorelease];
        test.drawInBackGround = _background;
        test.startIndex = arc4random_uniform(size.width);
        [self.view addSubview:test];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    for (GraphView *view in self.view.subviews) {
        [view updateView];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize size = [AppDelegate sizeInOrientation:toInterfaceOrientation];
    CGRect navframe = [[self.navigationController navigationBar] frame];
    int height = size.height - navframe.size.height;
    
    int count = [self.view.subviews count];
    int i = 0;
    for (GraphView *view in self.view.subviews) {
        CGRect rect = CGRectMake(0, (float)height/count * i, size.width, (float)height/count);
        view.frame = rect;
        i++;
    }
}

@end
