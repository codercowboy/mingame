/*
 
 UIView+TOFrameUtils.m
 
 This is a category on UIView that adds convenience methods that utilize
 FrameUtils operations to resize, move, center, debug log and more for
 a given UIView's frame.
 
 Usage instructions/examples are provided in UIView+FrameUtils.h.
 
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


#import "UIView+TOFrameUtils.h"

@implementation UIView (TOFrameUtils)

- (void) frameResizeToSize:(CGSize)size {
    self.frame = [TOFrameUtils frame:self.frame resizeToSize:size];
}

- (void) frameResizeToWidth:(CGFloat)width height:(CGFloat)height {
    self.frame = [TOFrameUtils frame:self.frame resizeToWidth:width height:height];
}

- (void) frameResizeToWidth:(CGFloat)width {
    self.frame = [TOFrameUtils frame:self.frame resizeToWidth:width];
}

- (void) frameResizeToHeight:(CGFloat)height {
    self.frame = [TOFrameUtils frame:self.frame resizeToHeight:height];
}

- (void) frameResizeByDelta:(CGSize)delta {
    self.frame = [TOFrameUtils frame:self.frame resizeByDelta:delta];
}

- (void) frameResizeByWidthDelta:(CGFloat)widthDelta heightDelta:(CGFloat)heightDelta {
    self.frame = [TOFrameUtils frame:self.frame resizeByWidthDelta:widthDelta heightDelta:heightDelta];
}

- (void) frameResizeByWidthDelta:(CGFloat)widthDelta {
    self.frame = [TOFrameUtils frame:self.frame resizeByWidthDelta:widthDelta];
}

- (void) frameResizeByHeightDelta:(CGFloat)heightDelta {
    self.frame = [TOFrameUtils frame:self.frame resizeByHeightDelta:heightDelta];
}

- (void) frameMoveToPosition:(CGPoint)position {
    self.frame = [TOFrameUtils frame:self.frame moveToPosition:position];
}

- (void) frameMoveToX:(CGFloat)x y:(CGFloat)y {
    self.frame = [TOFrameUtils frame:self.frame moveToX:x y:y];
}

- (void) frameMoveToX:(CGFloat)x {
    self.frame = [TOFrameUtils frame:self.frame moveToX:x];
}
- (void) frameMoveToY:(CGFloat)y {
    self.frame = [TOFrameUtils frame:self.frame moveToY:y];
}

- (void) frameMoveByDelta:(CGPoint)delta {
    self.frame = [TOFrameUtils frame:self.frame moveByDelta:delta];
}

- (void) frameMoveByXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta {
    self.frame = [TOFrameUtils frame:self.frame moveByXDelta:xDelta yDelta:yDelta];
}

- (void) frameMoveByXDelta:(CGFloat)xDelta {
    self.frame = [TOFrameUtils frame:self.frame moveByXDelta:xDelta];
}

- (void) frameMoveByYDelta:(CGFloat)yDelta {
    self.frame = [TOFrameUtils frame:self.frame moveByYDelta:yDelta];
}

- (void) frameCenterInFrame:(CGRect)frame {
    self.frame = [TOFrameUtils frame:self.frame centerInFrame:frame];
}

- (void) frameCenterHorizontallyInFrame:(CGRect)frame {
    self.frame = [TOFrameUtils frame:self.frame centerHorizontallyInFrame:frame];
}

- (void) frameCenterVerticallyInFrame:(CGRect)frame {
    self.frame = [TOFrameUtils frame:self.frame centerVerticallyInFrame:frame];
}

- (void) frameCenterInParent {
    [self frameCenterInFrame:self.superview.frame];
}

- (void) frameCenterHorizontallyInParent {
    [self frameCenterHorizontallyInFrame:self.superview.frame];
}

- (void) frameCenterVerticallyInParent {
    [self frameCenterVerticallyInFrame:self.superview.frame];
}

- (void) frameFix {
    self.frame = [TOFrameUtils fixFrame:self.frame];
}

- (void) framePrintWithLabel:(NSString *)label {
    [TOFrameUtils printFrame:self.frame label:label];
}

- (void) framePrint {
    [TOFrameUtils printFrame:self.frame];
}

@end
