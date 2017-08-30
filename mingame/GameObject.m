//
//  GameObject.m
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.position = CGPointMake(0, 0);
        self.originalPosition = self.position;
        self.type = UNDEFINED;
    }
    return self;
}

+ (GameObject *) createWithType:(GameObjectType)type position:(CGPoint)position sprite:(UIImage *)sprite {
    GameObject * obj = [[GameObject alloc] init];
    obj.type = type;
    obj.position = position;
    obj.originalPosition = obj.position;
    obj.sprite = sprite;
    return obj;
}

- (void) setUIImageBackgroundColor:(UIColor *)color {
    UIGraphicsBeginImageContext(CGSizeMake(10, 10));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
    CGContextStrokePath(context);
    /*
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextFillRect(context, CGRectMake(2, 2, 6, 6));
    CGContextStrokePath(context);
     */
    self.sprite = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void) resetToOriginalPosition {
    self.position = self.originalPosition;
}

@end
