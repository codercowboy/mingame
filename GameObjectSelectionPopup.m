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
        
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_SPACE]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_WALL]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_MONSTER]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_PLAYER]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_END]];
        
        [self moveToNextButtonRow];
        
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_1]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_2]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_3]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_4]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_KEY variant:GAMEOBJECTVARIANT_5]];
        
        [self moveToNextButtonRow];
        
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_1]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_2]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_3]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_4]];
        [self addGameObjectButton:[cfg createObjectWithType:GAMEOBJECTTYPE_DOOR variant:GAMEOBJECTVARIANT_5]];
        
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
        self.layer.borderWidth = 1.0f;
        
        [self resizeToFitButtons];
    }
    return self;
}

- (void) addGameObjectButton:(GameObject *)obj {
    [self addButtonWithData:obj sprite:[obj getCurrentSprite]];
}

@end
