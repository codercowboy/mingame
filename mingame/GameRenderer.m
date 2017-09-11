//
//  GameRenderer.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameRenderer.h"

@implementation GameRenderer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scaleMultiplier = 1;
        self.borderWidth = 0;
    }
    return self;
}

- (UIImage *) createEmptyImageWithSideLength:(int)sideLength {
    int scaledSideLength = sideLength * self.scaleMultiplier;
    UIGraphicsBeginImageContext(CGSizeMake(scaledSideLength, scaledSideLength));
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *) drawSquareWithSideLength:(int)sideLength {
    int scaledSideLength = sideLength * self.scaleMultiplier;
    int scaledBorderSize = self.borderWidth * self.scaleMultiplier;
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledSideLength, scaledSideLength));
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.borderColor != nil && self.borderWidth > 0) {
        CGContextSetFillColorWithColor(context, [self.borderColor CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, scaledSideLength, scaledSideLength));
        CGContextSetFillColorWithColor(context, [self.color CGColor]);
        CGContextFillRect(context, CGRectMake(scaledBorderSize, scaledBorderSize,
                                              scaledSideLength - (scaledBorderSize * 2),
                                              scaledSideLength - (scaledBorderSize * 2)));
    } else {
        CGContextSetFillColorWithColor(context, [self.color CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, scaledSideLength, scaledSideLength));
    }
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *) drawCircleWithSideLength:(int)sideLength {
    int scaledSideLength = sideLength * self.scaleMultiplier;
    int scaledBorderSize = self.borderWidth * self.scaleMultiplier;
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledSideLength, scaledSideLength));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect innerRect = CGRectMake(scaledBorderSize, scaledBorderSize,
                                  scaledSideLength - (scaledBorderSize * 2),
                                  scaledSideLength - (scaledBorderSize * 2));
    CGContextSetFillColorWithColor(context, [self.color CGColor]);
    CGContextFillEllipseInRect(context, innerRect);
    if (self.borderColor != nil && self.borderWidth > 0) {
        CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
        CGContextSetLineWidth(context, scaledBorderSize);
        CGContextStrokeEllipseInRect(context, innerRect);
        CGContextStrokePath(context);
    }
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *) drawTriangleWithSideLength:(int)sideLength {
    int scaledSideLength = sideLength * self.scaleMultiplier;
    int scaledBorderSize = self.borderWidth * self.scaleMultiplier;
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledSideLength, scaledSideLength));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //start top middle
    long middle = scaledSideLength / 2;
    CGContextMoveToPoint(context, middle, scaledBorderSize);
    //line to bottom right corner
    CGContextAddLineToPoint(context, scaledSideLength - scaledBorderSize, scaledSideLength - scaledBorderSize);
    //line to bottom left corner
    CGContextAddLineToPoint(context, scaledBorderSize, scaledSideLength - scaledBorderSize);
    //line back to top middle
    CGContextAddLineToPoint(context, middle, scaledBorderSize);

    CGContextSetFillColorWithColor(context, [self.color CGColor]);
    CGContextFillPath(context);

    if (self.borderColor != nil && self.borderWidth > 0) {
        //start top middle
        long middle = scaledSideLength / 2;
        CGContextMoveToPoint(context, middle, scaledBorderSize);
        //line to bottom right corner
        CGContextAddLineToPoint(context, scaledSideLength - scaledBorderSize, scaledSideLength - scaledBorderSize);
        //line to bottom left corner
        CGContextAddLineToPoint(context, scaledBorderSize, scaledSideLength - scaledBorderSize);
        //line back to top middle
        CGContextAddLineToPoint(context, middle, scaledBorderSize);
        //and another line to bottom right corner to make the top corner look nice
        CGContextAddLineToPoint(context, scaledSideLength - scaledBorderSize, scaledSideLength - scaledBorderSize);
        
        CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
        CGContextSetLineWidth(context, scaledBorderSize);
        CGContextStrokePath(context);
    }
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *) drawOctagonWithSideLength:(int)sideLength {
    int scaledSideLength = sideLength * self.scaleMultiplier;
    int scaledBorderSize = self.borderWidth * self.scaleMultiplier;
    int scaledThirdSideLength = scaledSideLength / 3;
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledSideLength, scaledSideLength));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*
      AB
     H  C
     G  D
      FE
     */
    
    //start at A
    CGContextMoveToPoint(context, scaledThirdSideLength, scaledBorderSize);
    //line to B
    CGContextAddLineToPoint(context, scaledThirdSideLength * 2, scaledBorderSize);
    //line to C
    CGContextAddLineToPoint(context, scaledSideLength - scaledBorderSize, scaledThirdSideLength);
    //line to D
    CGContextAddLineToPoint(context, scaledSideLength - scaledBorderSize, scaledThirdSideLength * 2);
    //line to E
    CGContextAddLineToPoint(context, scaledThirdSideLength * 2, scaledSideLength - scaledBorderSize);
    //line to F
    CGContextAddLineToPoint(context, scaledThirdSideLength, scaledSideLength - scaledBorderSize);
    //line to G
    CGContextAddLineToPoint(context, scaledBorderSize, scaledThirdSideLength * 2);
    //line to H
    CGContextAddLineToPoint(context, scaledBorderSize, scaledThirdSideLength);
    //line to A
    CGContextAddLineToPoint(context, scaledThirdSideLength, scaledBorderSize);
    //and another line to be to make corner around A look nice
    CGContextAddLineToPoint(context, scaledThirdSideLength * 2, scaledBorderSize);
    
    CGContextSetFillColorWithColor(context, [self.color CGColor]);
    CGContextFillPath(context);
    
    if (self.borderColor != nil && self.borderWidth > 0) {
        //start at A
        CGContextMoveToPoint(context, scaledThirdSideLength, scaledBorderSize);
        //line to B
        CGContextAddLineToPoint(context, scaledThirdSideLength * 2, scaledBorderSize);
        //line to C
        CGContextAddLineToPoint(context, scaledSideLength - scaledBorderSize, scaledThirdSideLength);
        //line to D
        CGContextAddLineToPoint(context, scaledSideLength - scaledBorderSize, scaledThirdSideLength * 2);
        //line to E
        CGContextAddLineToPoint(context, scaledThirdSideLength * 2, scaledSideLength - scaledBorderSize);
        //line to F
        CGContextAddLineToPoint(context, scaledThirdSideLength, scaledSideLength - scaledBorderSize);
        //line to G
        CGContextAddLineToPoint(context, scaledBorderSize, scaledThirdSideLength * 2);
        //line to H
        CGContextAddLineToPoint(context, scaledBorderSize, scaledThirdSideLength);
        //line to A
        CGContextAddLineToPoint(context, scaledThirdSideLength, scaledBorderSize);
        //and another line to be to make corner around A look nice
        CGContextAddLineToPoint(context, scaledThirdSideLength * 2, scaledBorderSize);
        
        
        CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
        CGContextSetLineWidth(context, scaledBorderSize);
        CGContextStrokePath(context);
    }
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *) addImageAsCenteredLayer:(UIImage *)newLayer onImage:(UIImage *)image {
    int originalWidth = image.size.width;
    int layerWidth = newLayer.size.width;
    int buffer = (originalWidth - layerWidth) / 2;
    
    UIGraphicsBeginImageContext(CGSizeMake(originalWidth, originalWidth));
    [image drawInRect:CGRectMake(0, 0, originalWidth, originalWidth)];
    [newLayer drawInRect:CGRectMake(buffer, buffer, layerWidth, layerWidth)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *) scaleImageDown:(UIImage *)originalImage sideLength:(int)sideLength {
    UIGraphicsBeginImageContext(CGSizeMake(sideLength, sideLength));
    [originalImage drawInRect:CGRectMake(0, 0, sideLength, sideLength)];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) drawBorderOnImage:(UIImage*)image top:(BOOL)top left:(BOOL)left right:(BOOL)right bottom:(BOOL)bottom {
    int scaledWidth = image.size.width * self.scaleMultiplier;
    int scaledBorderSize = self.borderWidth * self.scaleMultiplier;
    int buffer = scaledBorderSize / 2;
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledWidth));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [image drawInRect:CGRectMake(0, 0, scaledWidth, scaledWidth)];
    
    if (top) {
        CGContextMoveToPoint(context, 0, buffer);
        CGContextAddLineToPoint(context, scaledWidth, buffer);
        CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
        CGContextSetLineWidth(context, scaledBorderSize);
        CGContextStrokePath(context);
    }
    
    if (left) {
        CGContextMoveToPoint(context, buffer, 0);
        CGContextAddLineToPoint(context, buffer, scaledWidth);
        CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
        CGContextSetLineWidth(context, scaledBorderSize);
        CGContextStrokePath(context);
    }
    
    if (right) {
        CGContextMoveToPoint(context, scaledWidth - buffer, 0);
        CGContextAddLineToPoint(context, scaledWidth - buffer, scaledWidth);
        CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
        CGContextSetLineWidth(context, scaledBorderSize);
        CGContextStrokePath(context);
    }
    
    if (bottom) {
        CGContextMoveToPoint(context, 0, scaledWidth - buffer);
        CGContextAddLineToPoint(context, scaledWidth, scaledWidth - buffer);
        CGContextSetStrokeColorWithColor(context, [self.borderColor CGColor]);
        CGContextSetLineWidth(context, scaledBorderSize);
        CGContextStrokePath(context);
    }
    

    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

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
