//
//  GameObject.h
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

typedef enum {
    GAMEOBJECTTYPE_PLAYER = 1,
    GAMEOBJECTTYPE_END,
    GAMEOBJECTTYPE_WALL,
    GAMEOBJECTTYPE_KEY,
    GAMEOBJECTTYPE_DOOR,
    GAMEOBJECTTYPE_MONSTER,
    GAMEOBJECTTYPE_UNDEFINED
} GameObjectType;

typedef enum {
    GAMEOBJECTVARIANT_1 = 1,
    GAMEOBJECTVARIANT_2,
    GAMEOBJECTVARIANT_3,
    GAMEOBJECTVARIANT_4,
    GAMEOBJECTVARIANT_5,
    GAMEOBJECTVARIANT_6,
    GAMEOBJECTVARIANT_7,
    GAMEOBJECTVARIANT_8,
    GAMEOBJECTVARIANT_9,
    GAMEOBJECTVARIANT_UNDEFINED
} GameObjectVariant;

@interface GameObjectIdentifier : NSObject

@property GameObjectType type;
@property GameObjectVariant variant;

@end

@interface GameObject : NSObject

@property CGPoint position;
@property CGPoint originalPosition;
@property (strong) NSMutableArray * sprites;
@property GameObjectIdentifier * identifier;

+ (GameObject *) createWithType:(GameObjectType)type position:(CGPoint)position sprite:(UIImage *)sprite;
- (void) resetToOriginalPosition;
- (void) addSprite:(UIImage*)sprite;
- (UIImage *) getCurrentSprite;
- (GameObject *) clone;

@end
