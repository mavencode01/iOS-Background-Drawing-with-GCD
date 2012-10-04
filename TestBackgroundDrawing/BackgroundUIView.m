//
//  BackgroundUIView.m
//  TestBackgroundDrawing
//
//  Created by Bartel, Charles on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundUIView.h"

@interface BackgroundUIView() {
    
@private
    dispatch_queue_t _imageQueue;
    dispatch_queue_t _drawQueue;
    UIImage *_image;
    BOOL _isBusy;
    BOOL _drawInBackGround;
}

@end

@implementation BackgroundUIView

@synthesize isBusy = _isBusy;
@synthesize drawInBackGround = _drawInBackGround;

// Do the custom drawing to a UIImage buffer
// Render in the main UI thread or in a background thread
// Get the image buffer and draw it to the screen duing the drawRect method
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageQueue = dispatch_queue_create("image.view.dispatchqueue", DISPATCH_QUEUE_SERIAL);
        _drawQueue = dispatch_queue_create("draw.view.dispatchqueue", DISPATCH_QUEUE_SERIAL);
        _drawInBackGround = YES;
    }
    return self;
}

- (void)dealloc {
    dispatch_release(_imageQueue);
    dispatch_release(_drawQueue);
    [_image release];
    [super dealloc];
    NSLog(@"dealloc BackgroundUIView");
}

// For views that contain custom content using UIKit or Core Graphics, the system calls the view’s drawRect: method. 
// Your implementation of this method is responsible for drawing the view’s content into the current graphics context, 
// which is set up by the system automatically prior to calling this method. 
// This creates a static visual representation of your view’s content that can then be displayed on the screen.
- (void)drawRect:(CGRect)rect {
    NSLog(@"start of drawRect");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    UIImage *image = [self getImage];  
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);       
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, imageRect, image.CGImage);
    NSLog(@"end of drawRect");
}

// update the UIView
- (void)updateView {
    
    if (_isBusy) {
        NSLog(@"busy");
        return;
    }
    
    if (_drawInBackGround) {
        // Render in the background
        dispatch_async(_drawQueue, ^{
            _isBusy = YES;
            [self render];
        });
    } else {
        // Render on the main UI thread
        [self render];
    }
}

// Do the custom drawing and set the UIImage
- (void)render {
    NSLog(@"***start of render");
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);

    // override in subclass
    [self drawWithContext:context withWidth:self.frame.size.width withHeight:self.frame.size.height];
    
    // Returns an image based on the contents of the current bitmap-based graphics context
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setImage:theImage];
    UIGraphicsEndImageContext();
        
    NSLog(@"***end of render");
    _isBusy = NO;
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
}

// The image object will be accessed by multiple threads
// To ensure data integrity use a serial dispatch queue
- (UIImage *)getImage {
    __block UIImage *image = nil;
    dispatch_sync(_imageQueue, ^{
        image = [[_image copy] autorelease];
    });
    return image;
}

- (void)setImage:(UIImage *)image {
    dispatch_sync(_imageQueue, ^{
        [_image autorelease];
        _image = [image copy];
    });
}

// override in subclass
- (void)drawWithContext:(CGContextRef)ctx withWidth:(int)width withHeight:(int)height {
    
    NSException *exception = [NSException exceptionWithName: @"drawWithContext"
                                                     reason: @"override in subclass"
                                                   userInfo: nil];
    @throw exception;
}

@end
