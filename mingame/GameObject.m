//
//  GameObject.m
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameObject.h"

@implementation GameObjectIdentifier

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = GAMEOBJECTTYPE_UNDEFINED;
        self.variant = GAMEOBJECTVARIANT_UNDEFINED;
    }
    return self;
}

@end

@interface GameObject()

@property (weak) UIImage * currentSprite;

@end

@implementation GameObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.position = CGPointMake(0, 0);
        self.originalPosition = self.position;
        self.identifier = [[GameObjectIdentifier alloc] init];
        self.sprites = [NSMutableArray array];
    }
    return self;
}

+ (GameObject *) createWithType:(GameObjectType)type position:(CGPoint)position sprite:(UIImage *)sprite {
    GameObject * obj = [[GameObject alloc] init];
    obj.identifier.type = type;
    obj.position = position;
    obj.originalPosition = obj.position;
    [obj addSprite:sprite];
    return obj;
}

- (GameObject *) clone {
    GameObject * obj = [[GameObject alloc] init];
    obj.position = self.position;
    obj.originalPosition = self.originalPosition;
    obj.identifier.type = self.identifier.type;
    obj.identifier.variant = self.identifier.variant;
    for (UIImage * sprite in self.sprites) {
        [obj addSprite:sprite];
    }
    return obj;
}

- (void) addSprite:(UIImage*)sprite {
    if (sprite == nil) {
        return;
    }
    [self.sprites addObject:sprite];
    if ([self.sprites count] == 1) {
        self.currentSprite = sprite;
    }
}
- (UIImage *) getCurrentSprite {
    return self.currentSprite;
}

- (void) resetToOriginalPosition {
    self.position = self.originalPosition;
}

@end
