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
    }
    return self;
}

- (void) setUIImageBackgroundColor:(UIColor *)color {
    UIGraphicsBeginImageContext(CGSizeMake(10, 10));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
    CGContextStrokePath(context);
    self.sprite = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
