//
//  ViewController.m
//  TestBackgroundDrawing
//
//  Created by Bartel, Charles on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GraphViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Present the user with two options: draw in the background or on the main UI thread
    // The back button will remain responsive if the user picks the background option
    
    self.title = @"Test Background Drawing";
    CGRect rect = [AppDelegate rectInOrientation:[UIApplication sharedApplication].statusBarOrientation];
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect rect = [AppDelegate rectInOrientation:[UIApplication sharedApplication].statusBarOrientation];
    for (UITableView *view in self.view.subviews) {
        view.frame = rect;
    }
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
    // update the tableview to fit the new screen size
    CGRect rect = [AppDelegate rectInOrientation:toInterfaceOrientation];
    for (UITableView *view in self.view.subviews) {
        view.frame = rect;
    }
}

// UITableViewDelegate protocol
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GraphViewController *test = nil;
    if (indexPath.row == 0) {
        test = [[[GraphViewController alloc] initWithValue:YES] autorelease];
    } else {
        test = [[[GraphViewController alloc] initWithValue:NO] autorelease];
    }
    
    [self.navigationController pushViewController:test animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// UITableViewDataSource protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// UITableViewDataSource protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// UITableViewDataSource protocol
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Background";
    } else {
        cell.textLabel.text = @"Main UI Thread";
    }
    
    return cell;
}



@end
