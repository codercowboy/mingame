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
    
    width = width * 8;
    height = height * 8;
    borderWidth = borderWidth * 8;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [borderColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    
    if (borderWidth > 0) {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGRect innerRect = CGRectMake(borderWidth, borderWidth, width - (borderWidth *2), height - (borderWidth * 2));
        CGContextFillEllipseInRect(context, innerRect);
        CGContextSetStrokeColorWithColor(context, [[UIColor yellowColor] CGColor]);
        CGContextSetLineWidth(context, 4);
        CGContextStrokeEllipseInRect(context, innerRect);
        CGContextStrokePath(context);
        
    }
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
