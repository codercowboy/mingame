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
        CGContextSetStrokeColorWithColor(context, [UIColorFromHex(0xFFFF00) CGColor]);
        CGContextSetLineWidth(context, 4);
        CGContextStrokeEllipseInRect(context, innerRect);
        CGContextStrokePath(context);
        
        /*
        CGContextMoveToPoint(context, width / 2, borderWidth);
        CGContextAddLineToPoint(context, width - borderWidth, height - borderWidth);
        CGContextAddLineToPoint(context, borderWidth, height - borderWidth);
        CGContextAddLineToPoint(context, width / 2, borderWidth);
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillPath(context);
         */
    }
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) renderGrid:(UIColor *)color
             borderColor:(UIColor*)borderColor borderWidth:(int)borderWidth
                  tileHeight:(int)tileHeight tileWidth:(int)tileWidth
             columnCount:(int)columnCount rowCount:(int)rowCount {
    
    int multiplier = 1;
    tileWidth = tileWidth * multiplier;
    tileHeight = tileHeight * multiplier;

    UIGraphicsBeginImageContext(CGSizeMake(tileWidth, tileHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, tileWidth, tileHeight));
    UIImage * tileImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    int width = (tileWidth * columnCount);
    int height = (tileHeight * rowCount);
    
    if (borderWidth > 0) {
        borderWidth = borderWidth * multiplier;
        width += borderWidth * (columnCount + 1);
        height += borderWidth * (rowCount + 1);
    }
        
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    context = UIGraphicsGetCurrentContext();
    if (borderWidth > 0) {
        CGContextSetFillColorWithColor(context, [borderColor CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, width, height));
    }
    for (int col = 0; col < columnCount; col++) {
        for (int row = 0; row < rowCount; row++) {
            int x = col * tileWidth;
            int y = row * tileHeight;
            if (borderWidth > 0) {
                x += borderWidth * (col + 1);
                y += borderWidth * (row + 1);
            }
            CGRect rect = CGRectMake(x, y, tileWidth, tileHeight);
            [tileImage drawInRect:rect];
        }
    }
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) renderGameObjects:(NSArray*)objects backgroundImage:(UIImage *)backgroundImage
                     tileLength:(int)tileLength borderWidth:(int)borderWidth
                    columnCount:(int)columnCount rowCount:(int)rowCount {
    
    int width = (tileLength * columnCount);
    int height = (tileLength * rowCount);

    if (borderWidth > 0) {
        borderWidth = borderWidth;
        width += borderWidth * (columnCount + 1);
        height += borderWidth * (rowCount + 1);
    }

    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    if (backgroundImage != nil) {
        [backgroundImage drawInRect:CGRectMake(0, 0, width, height)];
    }
    if (objects != nil) {
        for (GameObject * obj in objects) {
            int col = obj.position.x;
            int row = obj.position.y;
            int x = col * tileLength;
            int y = row * tileLength;
            if (borderWidth > 0) {
                x += borderWidth * (col + 1);
                y += borderWidth * (row + 1);
            }
            [[obj getCurrentSprite] drawInRect:CGRectMake(x,y, tileLength, tileLength)];
        }
    }
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
