/*
 
 TOFrameUtils.h
 
 A collection of utilities that simplify common Objective C CGRect/Frame
 operations such as resizing, moving, centering, debug logging, and more.
 
 USAGE INSTRUCTIONS
 
 Using this class is simple. Simply include the source code from the
 FrameUtils.zip file in your Objective C project, then import this file in
 any file where you would like to use the methods provided by class.
 
 USAGE EXAMPLES
 
 #move a frame to position 0,0
 CGRect movedFrame = [FrameUtils frame:oldFrame moveToX:0 y:0];
 
 #move a frame left by 50 pixels
 CGRect movedFrame = [FrameUtils frame:oldFrame moveByXDelta:-50];
 
 #resize a frame to 50x100
 CGRect resizedFrame = [FrameUtils frame:oldFrame resizeToWidth:50 height:100];
 
 #resize a frame to be 75 pixels wider
 CGRect resizedFrame = [FrameUtils frame:oldFrame resizeByWidthDelta:75];
 
 #center a frame inside another frame
 CGRect centeredFrame = [FrameUtils frame:oldFrame centerInFrame:parentFrame];
 
 #print a frame to NSLog
 [FrameUtils printFrame:oldFrame];
 
 #"fix" a frame (set NAN dimensions to 0, and round all dimensions)
 CGRect fixedFrame = [FrameUtils fixFrame:oldFrame];
 
 If you're using these utilities often on UIView frame objects, consider using
 the UIVIew+FrameUtils category, more info is in UIView+FrameUtils.h.
 
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

@interface TOFrameUtils : NSObject

+ (CGRect) frame:(CGRect)frame resizeToSize:(CGSize)newSize;
+ (CGRect) frame:(CGRect)frame resizeToWidth:(CGFloat)width height:(CGFloat)height;
+ (CGRect) frame:(CGRect)frame resizeToWidth:(CGFloat)width;
+ (CGRect) frame:(CGRect)frame resizeToHeight:(CGFloat)height;

+ (CGRect) frame:(CGRect)frame resizeByDelta:(CGSize)delta;
+ (CGRect) frame:(CGRect)frame resizeByWidthDelta:(CGFloat)widthDelta heightDelta:(CGFloat)heightDelta;
+ (CGRect) frame:(CGRect)frame resizeByWidthDelta:(CGFloat)widthDelta;
+ (CGRect) frame:(CGRect)frame resizeByHeightDelta:(CGFloat)heightDelta;

+ (CGRect) frame:(CGRect)frame moveToPosition:(CGPoint)position;
+ (CGRect) frame:(CGRect)frame moveToX:(CGFloat)x y:(CGFloat)y;
+ (CGRect) frame:(CGRect)frame moveToX:(CGFloat)x;
+ (CGRect) frame:(CGRect)frame moveToY:(CGFloat)y;

+ (CGRect) frame:(CGRect)frame moveByDelta:(CGPoint)delta;
+ (CGRect) frame:(CGRect)frame moveByXDelta:(CGFloat)xDelta yDelta:(CGFloat)yDelta;
+ (CGRect) frame:(CGRect)frame moveByXDelta:(CGFloat)xDelta;
+ (CGRect) frame:(CGRect)frame moveByYDelta:(CGFloat)yDelta;

+ (CGRect) frame:(CGRect)frame centerInFrame:(CGRect)parentFrame;
+ (CGRect) frame:(CGRect)frame centerHorizontallyInFrame:(CGRect)parentFrame;
+ (CGRect) frame:(CGRect)frame centerVerticallyInFrame:(CGRect)parentFrame;

+ (CGFloat)fixFrameDim:(CGFloat)dim;
+ (CGRect) fixFrame:(CGRect)frame;

+ (CGRect) frameIpadLandscape;
+ (CGRect) frameIpadPortrait;
+ (CGRect) frameIPhoneLandscape;
+ (CGRect) frameIPhonePortrait;

+ (void) printFrame:(CGRect)frame label:(NSString *)label;
+ (void) printFrame:(CGRect)frame;

@end

#define toScreenHeight [[UIScreen mainScreen] bounds].size.height
#define toScreenWidth [[UIScreen mainScreen] bounds].size.width
#define toScreenIs4Inch (toScreenHeight == 568)
#define toScreenIs3dot5Inch (toScreenHeight == 480)

