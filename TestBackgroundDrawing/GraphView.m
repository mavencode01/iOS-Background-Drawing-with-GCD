//
//  GraphView.m
//  TestBackgroundDrawing
//
//  Created by Bartel, Charles on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "TestData.h"

@interface GraphView () {
    
@private
    int _startIndex;
}

@end

@implementation GraphView

@synthesize startIndex = _startIndex;

- (void)drawWithContext:(CGContextRef)ctx withWidth:(int)width withHeight:(int)height {
    
    // set line width and color
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] CGColor]);
    
    // create gradient
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {0.0, 0.5, 1.0, 0.2,  // Start color
        0.0, 0.5, 1.0, 1.0}; // End color
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    CGPoint startPoint, endPoint;
    startPoint.x = 0;
    startPoint.y = height;
    endPoint.x = 0;
    endPoint.y = 0;
    
    // create the path
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, height);
    
    int length = sizeof(testArray)/sizeof(float);
    int start = _startIndex;
    
    float zero = testArray[start] / maxNumber;
    CGContextAddLineToPoint(ctx, 0, height - (height * zero));
    int counter = 0;
    for (int i = start + 1; counter <= width; i++) {
        if (i >= length - 1) {
            i = 0;
        }
        float n = testArray[i] / maxNumber;
        CGContextAddLineToPoint(ctx, counter, height - (height * n));
        counter ++;
        
        // added for example purposes only
        // unnecessary for-loop added to slow down the drawing
        int temp = 0;
        for (int w = 0; w <= 100000; w++) {
            temp++;
        }
    }
    CGContextAddLineToPoint(ctx, width, height);
    CGContextClosePath(ctx);
    
    // draw gradient
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
        
    // draw the line
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, height - (height * zero));
    counter = 0;
    for (int i = start + 1; counter <= width; i++) {
        if (i >= length - 1) {
            i = 0;
        }
        float n = testArray[i] / maxNumber;
        CGContextAddLineToPoint(ctx, counter, height - (height * n));
        counter++;
    }
    CGContextDrawPath(ctx, kCGPathStroke);
}

@end
