//
//  LevelSerializer.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "LevelSerializer.h"
#import "GameBoard.h"

@implementation LevelSerializer

+ (GameLevel *) deserializeLevelFromString:(NSString*)encodedLevel cfg:(GameConfig *)cfg {
    GameLevel * level = [[GameLevel alloc] init];
    
    /*
        Level serialization map
        P = Player
        W = Wall
        S = Space
        ' ' = Space
        M = Monster
        E = End
        K = Key
        1 = Red Key
        2 = Green Key
        3 = Blue Key
        D = Door
        4 = Red D = Door
        5 = Green D = Door
        6 = Blue D = Door
        X = end of row
        \n = end of row
     */
    
    int x = 0;
    int y = 0;
    for (int i = 0; i < [encodedLevel length]; i++) {
        GameObjectType type = GAMEOBJECTTYPE_UNDEFINED;
        GameObjectVariant variant = GAMEOBJECTVARIANT_UNDEFINED;
        char c = [encodedLevel characterAtIndex:i];
        if (c == 'P') {
            type = GAMEOBJECTTYPE_PLAYER;
        } else if (c == 'W') {
            type = GAMEOBJECTTYPE_WALL;
        } else if (c == 'S' || c == ' ') {
            type = GAMEOBJECTTYPE_UNDEFINED;
            x++;
        } else if (c == 'M') {
            type = GAMEOBJECTTYPE_MONSTER;
        } else if (c == 'E') {
            type = GAMEOBJECTTYPE_END;
        } else if (c == 'K' || c == '1' || c == '2' || c == '3') {
            type = GAMEOBJECTTYPE_KEY;
            if (c == '1') {
                variant = GAMEOBJECTVARIANT_1;
            } else if (c == '2') {
                variant = GAMEOBJECTVARIANT_2;
            } else if (c == '3') {
                variant = GAMEOBJECTVARIANT_3;
            }
        } else if (c == 'D' || c == '4' || c == '5' || c == '6') {
            type = GAMEOBJECTTYPE_DOOR;
            if (c == '4') {
                variant = GAMEOBJECTVARIANT_1;
            } else if (c == '5') {
                variant = GAMEOBJECTVARIANT_2;
            } else if (c == '6') {
                variant = GAMEOBJECTVARIANT_3;
            }
        } else if (c == 'X' || c == '\n') {
            type = GAMEOBJECTTYPE_UNDEFINED;
            y++;
            x = 0;
        }
        if (type != GAMEOBJECTTYPE_UNDEFINED) {
            GameObject * obj = [cfg createObjectWithType:type variant:variant positionX:x positionY:y ];
            [level addObject:obj];
            x++;
        }
    }
    
    return level;
}

+ (NSString *) serializeLevel:(GameLevel *)level {
    NSMutableString * s = [[NSMutableString alloc] init];
    GameObject * obj = nil;
    GameBoard * board = [GameBoard createBoardForLevel:level];
    for (int y = 0; y < level.height; y++) {
        NSMutableString * line = [[NSMutableString alloc] init];
        for (int x = 0; x < level.width; x++) {
            obj = [board getObjectAtX:x y:y];
            if (obj == nil || obj.identifier.type == GAMEOBJECTTYPE_UNDEFINED) {
                [line appendString:@"S"];
            } else if (obj.identifier.type == GAMEOBJECTTYPE_PLAYER) {
                [line appendString:@"P"];
            } else if (obj.identifier.type == GAMEOBJECTTYPE_WALL) {
                [line appendString:@"W"];
            } else if (obj.identifier.type == GAMEOBJECTTYPE_MONSTER) {
                [line appendString:@"M"];
            } else if (obj.identifier.type == GAMEOBJECTTYPE_END) {
                [line appendString:@"E"];
            } else if (obj.identifier.type == GAMEOBJECTTYPE_KEY) {
                if (obj.identifier.variant == GAMEOBJECTVARIANT_1) {
                    [line appendString:@"1"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_2) {
                    [line appendString:@"2"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_3) {
                    [line appendString:@"3"];
                } else {
                    [line appendString:@"K"];
                }
            } else if (obj.identifier.type == GAMEOBJECTTYPE_DOOR) {
                if (obj.identifier.variant == GAMEOBJECTVARIANT_1) {
                    [line appendString:@"1"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_2) {
                    [line appendString:@"2"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_3) {
                    [line appendString:@"3"];
                } else {
                    [line appendString:@"D"];
                }
            }
        }
        //strip spaces off end of line
        int lastNonSpaceCharacter = -1;
        for (int i = 0; i < [line length]; i++) {
            if ([line characterAtIndex:i] != 'S') {
                lastNonSpaceCharacter = i;
            }
        }
        if (lastNonSpaceCharacter != -1 && lastNonSpaceCharacter < ([line length] -1)) {
            line = [NSMutableString stringWithString:[line substringWithRange:NSMakeRange(0, lastNonSpaceCharacter + 1)]];
        } else if (lastNonSpaceCharacter == -1) {
            line = [NSMutableString stringWithString:@""];
        }
        
        
        [line appendString:@"X"];
        [s appendString:line];
    }
    return s;
}

@end
