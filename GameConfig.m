//
//  GameConfig.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameConfig.h"
#import "GameRenderer.h"
#import "GameLevel.h"
#import "LevelSerializer.h"

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

- (void) saveConfig {
    NSLog(@"Saving user levels to file.");
    NSArray * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * saveFile = [[documentPath objectAtIndex:0] stringByAppendingPathComponent:@"UserLevels.txt"];
    NSMutableString * serializedLevels = [NSMutableString string];
    for (GameLevel * level in self.userLevels) {
        [serializedLevels appendString:[LevelSerializer serializeLevel:level]];
        [serializedLevels appendString:@"\n"];
    }
    NSLog(@"Serialized levels:\n%@", serializedLevels);
    NSError * error;
    BOOL succeed = [serializedLevels writeToFile:saveFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!succeed){
        NSLog(@"Error trying to save file: %@", [error localizedDescription]);
    } else {
        NSLog(@"Saved %ld levels to file.", [self.userLevels count]);
    }
}

- (void) loadConfig {
    NSLog(@"Loading user levels from file.");
    NSArray * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * saveFile = [[documentPath objectAtIndex:0] stringByAppendingPathComponent:@"UserLevels.txt"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveFile];
    if (!fileExists) {
        NSLog(@"Nothing to load from file, there's nothing there.");
        return;
    }
    NSError * error;
    NSString * serializedLevels = [NSString stringWithContentsOfFile:saveFile encoding:NSUTF8StringEncoding error:&error];
    if (serializedLevels == nil) {
        NSLog(@"Error trying to read file: %@", [error localizedDescription]);
        return;
    }
    
    for (NSString * levelAsString in [serializedLevels componentsSeparatedByString:@"\n"]) {
        NSString * trimmedString = [levelAsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (levelAsString == nil || trimmedString == nil || [@"" isEqualToString:trimmedString]) {
            continue;
        }
        GameLevel * level = [LevelSerializer deserializeLevelFromString:levelAsString cfg:self];
        [self.userLevels addObject:level];
    }
    NSLog(@"Loaded %ld levels from file.", [self.userLevels count]);
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.userLevels = [NSMutableArray array];
        self.objectsByType = [NSMutableDictionary dictionary];
        
        self.purpleColor = UIColorFromHex(0x996699);
        self.greenColor = UIColorFromHex(0x339900);
        self.blueColor = UIColorFromHex(0x0066CC);
        self.redColor = UIColorFromHex(0xCC0033);
        self.orangeColor = UIColorFromHex(0xFF9933);
        self.pinkColor = UIColorFromHex(0xFF99FF);
        self.greyColor = UIColorFromHex(0x555454);
        self.yellowColor = UIColorFromHex(0xEEC933);
        //self.yellowColor = UIColorFromHex(0xFFFF00);
        self.tealColor = UIColorFromHex(0x339999);
        
        self.backgroundColor = UIColorFromHex(0x333333);
                
        self.playerColor = self.blueColor;
        self.endColor = self.greenColor;
        self.wallColor = [UIColor blackColor];
        self.monsterColor = self.redColor;
        
        GameRenderer * r = [[GameRenderer alloc] init];
        r.scaleMultiplier = 8;
        
        int sideLength = 40;
        
        r.color = [UIColor whiteColor];
        
        UIImage * sprite = [r drawSquareWithSideLength:sideLength];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_SPACE variant:GAMEOBJECTVARIANT_UNDEFINED sprite:sprite];
        
        r.borderWidth = 1;
        r.borderColor = self.greyColor;
        r.color = self.wallColor;
        sprite = [r drawSquareWithSideLength:sideLength];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_WALL variant:GAMEOBJECTVARIANT_UNDEFINED sprite:sprite];
        UIImage * wallImage = sprite;
        
        r.borderWidth = 0;
        
        UIImage * blankImage = [r createEmptyImageWithSideLength:sideLength];
        
        r.color = self.playerColor;
        sprite = [r drawCircleWithSideLength:((sideLength / 3) * 2)];
        sprite = [r addImageAsCenteredLayer:sprite onImage:blankImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_PLAYER variant:GAMEOBJECTVARIANT_UNDEFINED sprite:sprite];
        
        r.color = self.endColor;
        sprite = [r drawCircleWithSideLength:((sideLength / 3) * 2)];
        sprite = [r addImageAsCenteredLayer:sprite onImage:blankImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_END variant:GAMEOBJECTVARIANT_UNDEFINED sprite:sprite];
        
        r.borderColor = self.greyColor;
        r.borderColor = [UIColor whiteColor];
        r.borderWidth = 1;
        
        r.borderColor = self.greyColor;
        r.color = self.monsterColor;
        r.borderWidth = 1;
        sprite = [r drawOctagonWithSideLength:((sideLength / 5) * 3)];
        sprite = [r addImageAsCenteredLayer:sprite onImage:blankImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_MONSTER variant:GAMEOBJECTVARIANT_UNDEFINED sprite:sprite];
        
        r.borderColor = [UIColor whiteColor];
        r.borderWidth = 1;
        
        //keys
        r.color = self.tealColor;
        sprite = [r drawCircleWithSideLength:(sideLength / 3)];
        sprite = [r addImageAsCenteredLayer:sprite onImage:blankImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_1 sprite:sprite];
        
        r.color = self.purpleColor;
        sprite = [r drawCircleWithSideLength:(sideLength / 3)];
        sprite = [r addImageAsCenteredLayer:sprite onImage:blankImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_2 sprite:sprite];
        
        r.color = self.yellowColor;
        sprite = [r drawCircleWithSideLength:(sideLength / 3)];
        sprite = [r addImageAsCenteredLayer:sprite onImage:blankImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_3 sprite:sprite];
        
        r.color = self.orangeColor;
        sprite = [r drawCircleWithSideLength:(sideLength / 3)];
        sprite = [r addImageAsCenteredLayer:sprite onImage:blankImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_4 sprite:sprite];
        
        r.color = self.pinkColor;
        sprite = [r drawCircleWithSideLength:(sideLength / 3)];
        sprite = [r addImageAsCenteredLayer:sprite onImage:blankImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_5 sprite:sprite];

        //doors
        r.color = self.tealColor;
        int doorEmblemSideLength = (sideLength / 3) * 2;
        sprite = [r drawSquareWithSideLength:doorEmblemSideLength];
        sprite = [r addImageAsCenteredLayer:sprite onImage:wallImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_1 sprite:sprite];
        
        r.color = self.purpleColor;
        sprite = [r drawSquareWithSideLength:doorEmblemSideLength];
        sprite = [r addImageAsCenteredLayer:sprite onImage:wallImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_2 sprite:sprite];
        
        r.color = self.yellowColor;
        sprite = [r drawSquareWithSideLength:doorEmblemSideLength];
        sprite = [r addImageAsCenteredLayer:sprite onImage:wallImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_3 sprite:sprite];
        
        r.color = self.orangeColor;
        sprite = [r drawSquareWithSideLength:doorEmblemSideLength];
        sprite = [r addImageAsCenteredLayer:sprite onImage:wallImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_4 sprite:sprite];
        
        r.color = self.pinkColor;
        sprite = [r drawSquareWithSideLength:doorEmblemSideLength];
        sprite = [r addImageAsCenteredLayer:sprite onImage:wallImage];
        [self createPrototypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_5 sprite:sprite];
    }
    return self;
}

- (GameObject *) createPrototypeObjectWithType:(GameObjectType)type variant:(GameObjectVariant)variant sprite:(UIImage *)sprite {
    GameObject * o = [GameObject createWithType:type position:CGPointMake(0, 0) sprite:sprite];
    o.identifier.variant = variant;
    NSString * key = [NSString stringWithFormat:@"%d:%d", type, variant];
    [self.objectsByType setObject:o forKey:key];
    [o addSprite:sprite];
    return o;
}

- (GameObject *) createObjectWithType:(GameObjectType)type {
    return [self createObjectWithType:type variant:GAMEOBJECTVARIANT_UNDEFINED positionX:0 positionY:0];
}

- (GameObject *) createObjectWithType:(GameObjectType)type variant:(GameObjectVariant)variant {
    return [self createObjectWithType:type variant:variant positionX:0 positionY:0];
}

- (GameObject *) createObjectWithType:(GameObjectType)type variant:(GameObjectVariant)variant positionX:(int)x positionY:(int)y {
    NSString * key = [NSString stringWithFormat:@"%d:%d", type, variant];
    GameObject * o = [self.objectsByType objectForKey:key];
    if (o == nil) {
        NSString * msg = @"Can't create game object with type %d and variant %d, have you already configured it?";
        NSString * error = [NSString stringWithFormat:msg, type, variant];
        NSException * e = [NSException exceptionWithName:@"GameObjectPrototypeMissing" reason:error userInfo:nil];
        @throw e;
    }
    o = [o clone];
    o.position = CGPointMake(x, y);
    o.originalPosition = o.position;
    return o;
}

@end
