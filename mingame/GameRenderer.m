//
//  GameRenderer.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameRenderer.h"

@implementation GameRenderer

+ (UIImage *) createSpriteWithColor:(UIColor *)color height:(int)height width:(int)width {
    return [GameRenderer createSpriteWithColor:color borderColor:nil borderWidth:0 height:height width:width];
}

+ (UIImage *) createSpriteWithColor:(UIColor *)color borderColor:(UIColor*)borderColor
                        borderWidth:(int)borderWidth height:(int)height width:(int)width {
    
    if (borderColor == nil) {
        borderColor = color;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [borderColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    CGContextStrokePath(context);
    
    if (borderWidth > 0) {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, CGRectMake(borderWidth, borderWidth,
                                              width - (borderWidth *2), height - (borderWidth * 2)));
        CGContextStrokePath(context);
    }
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
