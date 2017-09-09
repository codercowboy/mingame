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

        
        self.backgroundColor = UIColorFromHex(0x333333);
                
        self.playerColor = UIColorFromHex(0x339999);
        self.keyColor = UIColorFromHex(0xFFFF00);
        self.endColor = UIColorFromHex(0xEEC933);
        self.doorColor = UIColorFromHex(0x996633);
        self.wallColor = [UIColor blackColor];
        self.monsterColor = self.redColor;
        
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_SPACE variant:GAMEOBJECTVARIANT_UNDEFINED color:[UIColor whiteColor]];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_PLAYER variant:GAMEOBJECTVARIANT_UNDEFINED color:self.playerColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_WALL variant:GAMEOBJECTVARIANT_UNDEFINED color:self.wallColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_END variant:GAMEOBJECTVARIANT_UNDEFINED color:self.endColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_MONSTER variant:GAMEOBJECTVARIANT_UNDEFINED color:self.monsterColor];
        
        //keys
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_1 color:self.backgroundColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_2 color:self.backgroundColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_3 color:self.backgroundColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_4 color:self.backgroundColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_5 color:self.backgroundColor];
        
        //doors
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_1 color:self.backgroundColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_2 color:self.backgroundColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_3 color:self.backgroundColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_4 color:self.backgroundColor];
        [self createProtoTypeObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_5 color:self.backgroundColor];
        [self loadConfig];
        
    }
    return self;
}

- (GameObject *) createProtoTypeObjectWithType:(GameObjectType)type variant:(GameObjectVariant)variant color:(UIColor*)color {
    UIColor * borderColor = nil;
    if (variant == GAMEOBJECTVARIANT_1) {
        borderColor = self.greenColor;
    } else if (variant == GAMEOBJECTVARIANT_2) {
        borderColor = self.purpleColor;
    } else if (variant == GAMEOBJECTVARIANT_3) {
        borderColor = self.blueColor;
    } else if (variant == GAMEOBJECTVARIANT_4) {
        borderColor = self.orangeColor;
    } else if (variant == GAMEOBJECTVARIANT_5) {
        borderColor = self.pinkColor;
    }
    int borderWidth = (borderColor == nil) ? 0 : 2;
    if (type == GAMEOBJECTTYPE_DOOR) {
        color = borderColor;
        borderWidth = 0;
    }
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
        NSLog(@"WARNING: Can't create game object with type %d and variant %d, have you already configured it?", type, variant);
        return nil;
    }
    o = [o clone];
    o.position = CGPointMake(x, y);
    o.originalPosition = o.position;
    return o;
}

@end
