//
//  GameObjectSelectionPopup.m
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameObjectSelectionPopup.h"

@implementation GameObjectSelectionPopup

- (instancetype)init {
    self = [super init];
    if (self) {
        GameConfig * cfg = [GameConfig sharedInstance];
        
        self.backgroundColor = cfg.backgroundColor;
        
        NSMutableArray * objects = [NSMutableArray array];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_WALL]];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_MONSTER]];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_1]];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_2]];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_3]];
        
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_PLAYER]];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_END]];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_1]];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_2]];
        [objects addObject:[cfg createObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_3]];
        
        for (int i = 0; i < [objects count]; i++) {
            if (i == 5) {
                [self moveToNextButtonRow];
            }
            GameObject * obj = (GameObject *) [objects objectAtIndex:i];
            [self addButtonWithData:obj sprite:[obj getCurrentSprite]];
        }
        
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
        self.layer.borderWidth = 1.0f;
        
        [self resizeToFitButtons];
    }
    return self;
}

@end
