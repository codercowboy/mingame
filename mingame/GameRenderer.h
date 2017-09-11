//
//  GameRenderer.h
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameRenderer : NSObject

@property int spriteSideLength;
@property (strong) UIColor * color;
@property (strong) UIColor * borderColor;
@property int borderWidth;
@property int scaleMultiplier;

+ (UIImage *) createSpriteWithColor:(UIColor *)color height:(int)height width:(int)width;
+ (UIImage *) createSpriteWithColor:(UIColor *)color borderColor:(UIColor*)borderColor
                        borderWidth:(int)borderWidth height:(int)height width:(int)width;

+ (UIImage *) renderGrid:(UIColor *)color
             borderColor:(UIColor*)borderColor borderWidth:(int)borderWidth
              tileHeight:(int)tileHeight tileWidth:(int)tileWidth
             columnCount:(int)columnCount rowCount:(int)rowCount;

+ (UIImage *) renderGameObjects:(NSArray*)objects backgroundImage:(UIImage *)backgroundImage
                     tileLength:(int)tileLength borderWidth:(int)borderWidth
                    columnCount:(int)columnCount rowCount:(int)rowCount;

- (UIImage *) createEmptyImageWithSideLength:(int)sideLength;
- (UIImage *) drawSquareWithSideLength:(int)sideLength;
- (UIImage *) drawCircleWithSideLength:(int)sideLength;
- (UIImage *) drawTriangleWithSideLength:(int)sideLength;
- (UIImage *) drawOctagonWithSideLength:(int)sideLength;
- (UIImage *) addImageAsCenteredLayer:(UIImage *)newLayer onImage:(UIImage *)image;
- (UIImage *) scaleImageDown:(UIImage *)originalImage sideLength:(int)sideLength;
- (UIImage *) drawBorderOnImage:(UIImage*)image top:(BOOL)top left:(BOOL)left right:(BOOL)right bottom:(BOOL)bottom;

@end
