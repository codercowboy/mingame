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
        1 = Red Key
        2 = Green Key
        3 = Blue Key
        4 = Orange Key
        5 = Purple Key
        6 = Red Door
        7 = Green Door
        8 = Blue Door
        9 = Orange Door
        0 = Purple Door
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
        } else if (c == '1' || c == '2' || c == '3' || c == '4' || c == '5') {
            type = GAMEOBJECTTYPE_KEY;
            if (c == '1') {
                variant = GAMEOBJECTVARIANT_1;
            } else if (c == '2') {
                variant = GAMEOBJECTVARIANT_2;
            } else if (c == '3') {
                variant = GAMEOBJECTVARIANT_3;
            } else if (c == '4') {
                variant = GAMEOBJECTVARIANT_4;
            } else if (c == '5') {
                variant = GAMEOBJECTVARIANT_5;
            }
        } else if (c == '6' || c == '7' || c == '8' || c == '9' || c == '0') {
            type = GAMEOBJECTTYPE_DOOR;
            if (c == '6') {
                variant = GAMEOBJECTVARIANT_1;
            } else if (c == '7') {
                variant = GAMEOBJECTVARIANT_2;
            } else if (c == '8') {
                variant = GAMEOBJECTVARIANT_3;
            } else if (c == '9') {
                variant = GAMEOBJECTVARIANT_4;
            } else if (c == '0') {
                variant = GAMEOBJECTVARIANT_5;
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
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_4) {
                    [line appendString:@"4"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_5) {
                    [line appendString:@"5"];
                } else {
                    [line appendString:@"K"];
                }
            } else if (obj.identifier.type == GAMEOBJECTTYPE_DOOR) {
                if (obj.identifier.variant == GAMEOBJECTVARIANT_1) {
                    [line appendString:@"6"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_2) {
                    [line appendString:@"7"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_3) {
                    [line appendString:@"8"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_4) {
                    [line appendString:@"9"];
                } else if (obj.identifier.variant == GAMEOBJECTVARIANT_5) {
                    [line appendString:@"0"];
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
