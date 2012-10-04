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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageQueue = dispatch_queue_create("image.view.dispatchqueue", NULL);
        _drawQueue = dispatch_queue_create("draw.view.dispatchqueue", NULL);
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

- (void)render {
    NSLog(@"***start of render");
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);

    [self drawWithContext:context withWidth:self.frame.size.width withHeight:self.frame.size.height];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setImage:theImage];
    UIGraphicsEndImageContext();
        
    NSLog(@"***end of render");
    _isBusy = NO;
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
}

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
