//
//  LevelSerializer.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "LevelSerializer.h"

@implementation LevelSerializer

+ (GameLevel *) deserializeLevelFromString:(NSString*)encodedLevel {
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
    
    GameConfig * cfg = [GameConfig sharedInstance];
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

@end
