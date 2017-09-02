/*
 
 TOFrameUtils.m
 
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

#import "TOFrameUtils.h"

@implementation TOFrameUtils

+ (CGRect) frame:(CGRect)frame resizeToSize:(CGSize)newSize {
    return CGRectMake(frame.origin.x, frame.origin.y, newSize.width, newSize.height);
}

+ (CGRect) frame:(CGRect)frame resizeToWidth:(CGFloat)width height:(CGFloat)height {
    return CGRectMake(frame.origin.x, frame.origin.y, width, height);
}

+ (CGRect) frame:(CGRect)frame resizeToWidth:(CGFloat)width {
    return CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame resizeToHeight:(CGFloat)height {
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
}

+ (CGRect) frame:(CGRect)frame resizeByDelta:(CGSize)delta {
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + delta.width, frame.size.height + delta.height);
}

+ (CGRect) frame:(CGRect)frame resizeByWidthDelta:(CGFloat)widthDelta heightDelta:(CGFloat)heightDelta {
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + widthDelta, frame.size.height + heightDelta);
}

+ (CGRect) frame:(CGRect)frame resizeByWidthDelta:(CGFloat)widthDelta {
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + widthDelta, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame resizeByHeightDelta:(CGFloat)heightDelta {
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + heightDelta);
}

+ (CGRect) frame:(CGRect)frame moveToPosition:(CGPoint)position {
    return CGRectMake(position.x, position.y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveToX:(CGFloat)x y:(CGFloat)y {
    return CGRectMake(x, y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveToX:(CGFloat)x {
    return CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveToY:(CGFloat)y {
    return CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
}


+ (CGRect) frame:(CGRect)frame moveByDelta:(CGPoint)delta {
    return CGRectMake(frame.origin.x + delta.x, frame.origin.y + delta.y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveByXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta {
    return CGRectMake(frame.origin.x + xDelta, frame.origin.y + yDelta, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveByXDelta:(CGFloat)xDelta {
    return CGRectMake(frame.origin.x + xDelta, frame.origin.y, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame moveByYDelta:(CGFloat)yDelta {
    return CGRectMake(frame.origin.x, frame.origin.y + yDelta, frame.size.width, frame.size.height);
}

+ (CGRect) frame:(CGRect)frame centerInFrame:(CGRect)parentFrame {
    CGFloat x = parentFrame.origin.x + ((parentFrame.size.width - frame.size.width) / 2);
    CGFloat y = parentFrame.origin.y + ((parentFrame.size.height - frame.size.height) / 2);
    return [TOFrameUtils frame:frame moveToX:x y:y];
}

+ (CGRect) frame:(CGRect)frame centerHorizontallyInFrame:(CGRect)parentFrame {
    CGFloat x = parentFrame.origin.x + ((parentFrame.size.width - frame.size.width) / 2);
    return [TOFrameUtils frame:frame moveToX:x];
}

+ (CGRect) frame:(CGRect)frame centerVerticallyInFrame:(CGRect)parentFrame {
    CGFloat y = parentFrame.origin.y + ((parentFrame.size.height - frame.size.height) / 2);
    return [TOFrameUtils frame:frame moveToY:y];
}

+ (CGFloat)fixFrameDim:(CGFloat)dim {
    if (isnan(dim)) {
        return 0.0f;
    }
    return round(dim);
}

+ (CGRect) fixFrame:(CGRect)frame {
    return CGRectMake([TOFrameUtils fixFrameDim:frame.origin.x],
                      [TOFrameUtils fixFrameDim:frame.origin.y],
                      [TOFrameUtils fixFrameDim:frame.size.width],
                      [TOFrameUtils fixFrameDim:frame.size.height]);
}

+ (CGRect) frameIpadLandscape {
    return CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f);
}

+ (CGRect) frameIpadPortrait {
    return CGRectMake(0.0f, 0.0f, 768.0f, 1024.0f);
}

+ (CGRect) frameIPhoneLandscape {
    return CGRectMake(0.0f, 0.0f, 480.0f, 320.0f);
}

+ (CGRect) frameIPhonePortrait {
    return CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
}

+ (void) printFrame:(CGRect)frame label:(NSString *)label {
    CGFloat ratio = frame.size.width / frame.size.height;
    NSLog(@"Frame: %@, origin: %dx%d, size: %dx%d, ratio (w/h): %2.2f", ((label == nil) ? @"" : label),
          (int) frame.origin.x, (int) frame.origin.y, (int) frame.size.width, (int) frame.size.height, ratio);
}

+ (void) printFrame:(CGRect)frame {
    [TOFrameUtils printFrame:frame label:nil];
}

@end
