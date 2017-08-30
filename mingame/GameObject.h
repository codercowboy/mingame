//
//  GameObject.h
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    PLAYER = 1,
    END,
    WALL,
    KEY,
    DOOR,
    MONSTER,
    UNDEFINED
} GameObjectType;

@interface GameObject : NSObject

@property CGPoint position;
@property CGPoint originalPosition;
@property (strong) UIImage * sprite;
@property GameObjectType type;

+ (GameObject *) createWithType:(GameObjectType)type position:(CGPoint)position sprite:(UIImage *)sprite;
- (void) setUIImageBackgroundColor:(UIColor *)color;
- (void) resetToOriginalPosition;

@end
