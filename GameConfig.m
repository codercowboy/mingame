//
//  GameConfig.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameConfig.h"
#import "GameRenderer.h"

@interface GameConfig()

@property (strong) NSMutableDictionary * objectsByType;

@end

@implementation GameConfig

+ (GameConfig *) sharedInstance {
    static GameConfig * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameConfig alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.objectsByType = [NSMutableDictionary dictionary];
        
        self.redColor = UIColorFromHex(0xEF2929);
        self.greenColor = UIColorFromHex(0x4F8112);
        self.blueColor = UIColorFromHex(0x0000FF);
        
        self.backgroundColor = UIColorFromHex(0xFAFAFA);
                
        self.playerColor = self.redColor;
        self.endColor = self.greenColor;
        self.keyColor = UIColorFromHex(0xEDD400);
        self.doorColor = UIColorFromHex(0xC17D11);
        self.doorColor = [UIColor brownColor];
        self.wallColor = [UIColor blackColor];
        self.monsterColor = [UIColor orangeColor];
        
        
        
        self.prototypePlayer = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_PLAYER
                                                           variant:GAMEOBJECTVARIANT_UNDEFINED
                                                             color:self.playerColor];
        
        self.prototypeWall = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_WALL
                                                           variant:GAMEOBJECTVARIANT_UNDEFINED
                                                             color:self.wallColor];
        
        self.prototypeEnd = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_END
                                                        variant:GAMEOBJECTVARIANT_UNDEFINED
                                                          color:self.endColor];
        
        self.prototypeMonster = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_MONSTER
                                                            variant:GAMEOBJECTVARIANT_UNDEFINED
                                                              color:self.monsterColor];
        
        //keys
        self.prototypeKey = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY
                                                           variant:GAMEOBJECTVARIANT_UNDEFINED
                                                             color:self.keyColor];
        
        self.prototypeKeyRed = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY
                                                        variant:GAMEOBJECTVARIANT_1
                                                          color:self.backgroundColor];
        
        self.prototypeKeyGreen = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY
                                                            variant:GAMEOBJECTVARIANT_2
                                                              color:self.backgroundColor];
        
        self.prototypeKeyBlue = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY
                                                            variant:GAMEOBJECTVARIANT_3
                                                              color:self.backgroundColor];
        
        //doors
        self.prototypeDoor = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR
                                                           variant:GAMEOBJECTVARIANT_UNDEFINED
                                                             color:self.doorColor];
        
        self.prototypeDoorRed = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR
                                                           variant:GAMEOBJECTVARIANT_1
                                                             color:self.doorColor];
        
        self.prototypeDoorGreen = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR
                                                             variant:GAMEOBJECTVARIANT_2
                                                               color:self.doorColor];
        
        self.prototypeDoorBlue = [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR
                                                            variant:GAMEOBJECTVARIANT_3
                                                              color:self.doorColor];
        
        
        
    }
    return self;
}

- (GameObject *) createProtoTypeObjectWithType:(GameObjectType)type variant:(GameObjectVariant)variant color:(UIColor*)color {
    UIColor * borderColor = nil;
    if (variant == GAMEOBJECTVARIANT_1) {
        borderColor = self.redColor;
    } else if (variant == GAMEOBJECTVARIANT_2) {
        borderColor = self.greenColor;
    } else if (variant == GAMEOBJECTVARIANT_3) {
        borderColor = self.blueColor;
    }
    int borderWidth = (borderColor == nil) ? 0 : 2;
    if (borderColor != nil) {
        UIColor * tmpColor = color;
        color = borderColor;
        borderColor = tmpColor;
    }
    UIImage * sprite = [GameRenderer createSpriteWithColor:color borderColor:borderColor
                                               borderWidth:borderWidth height:10 width:10];
    GameObject * o = [GameObject createWithType:type position:CGPointMake(0, 0) sprite:sprite];
    o.identifier.variant = variant;
    NSString * key = [NSString stringWithFormat:@"%d:%d", type, variant];
    [self.objectsByType setObject:o forKey:key];
    return o;
    
}

- (GameObject *) createObjectWithType:(GameObjectType)type variant:(GameObjectVariant)variant positionX:(int)x positionY:(int)y {
    NSString * key = [NSString stringWithFormat:@"%d:%d", type, variant];
    GameObject * o = [self.objectsByType objectForKey:key];
    if (o == nil) {
        NSLog(@"WARNING: Can't create game object with type %d and varient %d, have you already configured it?", type, variant);
        return nil;
    }
    o = [o clone];
    o.position = CGPointMake(x, y);
    o.originalPosition = o.position;
    return o;
}

@end
