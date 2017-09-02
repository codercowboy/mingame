/*
 
 UIView+TOFrameUtils.h
 
 This is a category on UIView that adds convenience methods that utilize
 FrameUtils operations to resize, move, center, debug log and more for
 a given UIView's frame.
 
 USAGE INSTRUCTIONS
 
 Using this category is simple. Simply include the source code from the
 FrameUtils.zip file in your Objective C project, then import this file in
 any file where you would like to use the methods provided by this category.
 
 USAGE EXAMPLES
 
 #move a UIView's frame to position 0,0
 [view frameMoveToX:0 y:0];
 
 #move a UIView's frame left by 50 pixels
 [view frameMoveByXDelta:-50];
 
 #resize a UIView's frame to 50x100
 [view frameResizeToWidth:50 height:100];
 
 #resize a UIView's frame to be 75 pixels wider
 [view frameResizeByWidthDelta:75];
 
 #center a UIView's frame inside another view's frame
 [view frameCenterInFrame:otherView.frame];
 
 #print a UIView's frame to NSLog
 [view framePrint];
 
 #"fix" a UIView's frame (set NAN dimensions to 0, and round all dimensions)
 [view frameFix];
 
 Additional utility methods are provided in FrameUtils.
 
 ---
 
 This code comes from TumbleOnUtils, which is an open-source collection of
 iOS utilities developed for TumbleOn and other projects.
 
 https://github.com/codercowboy/TumbleOnUtils/
 
 Authors
 * Jason Baker (jason@onejasonforsale.com)
 * Adam Zacharski (zacharski@gmail.com)
 
 TumbleOnUtils is licensed with the Apache license. For details, see:
 
 https://github.com/codercowboy/TumbleOnUtils/blob/master/LICENSE.md
 
 Copyright (c) 2012-2013, Pocket Sized Giraffe, LLC. All rights reserved.
 
 */

#import <Foundation/Foundation.h>
#import "TOFrameUtils.h"

@interface UIView (TOFrameUtils)

- (void) frameResizeToSize:(CGSize)size;
- (void) frameResizeToWidth:(CGFloat)width height:(CGFloat)height;
- (void) frameResizeToWidth:(CGFloat)width;
- (void) frameResizeToHeight:(CGFloat)height;

- (void) frameResizeByDelta:(CGSize)delta;
- (void) frameResizeByWidthDelta:(CGFloat)widthDelta heightDelta:(CGFloat)heightDelta;
- (void) frameResizeByWidthDelta:(CGFloat)widthDelta;
- (void) frameResizeByHeightDelta:(CGFloat)heightDelta;

- (void) frameMoveToPosition:(CGPoint)position;
- (void) frameMoveToX:(CGFloat)x y:(CGFloat)y;
- (void) frameMoveToX:(CGFloat)x;
- (void) frameMoveToY:(CGFloat)y;

- (void) frameMoveByDelta:(CGPoint)delta;
- (void) frameMoveByXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta;
- (void) frameMoveByXDelta:(CGFloat)xDelta;
- (void) frameMoveByYDelta:(CGFloat)yDelta;

- (void) frameCenterInFrame:(CGRect)frame;
- (void) frameCenterHorizontallyInFrame:(CGRect)frame;
- (void) frameCenterVerticallyInFrame:(CGRect)frame;

- (void) frameCenterInParent;
- (void) frameCenterHorizontallyInParent;
- (void) frameCenterVerticallyInParent;

- (void) frameFix;

- (void) framePrintWithLabel:(NSString *)label;
- (void) framePrint;

@end
