//
//  ModeSelectionPopup.m
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "ModeSelectionPopup.h"
#import "GameObjectSelectionPopup.h"

@interface ModeSelectionPopup()
@property (strong) UIButton * objectButton;
@end

@implementation ModeSelectionPopup

- (instancetype)init {
    self = [super init];
    if (self) {
        self.objectButton = [self addButtonWithData:@"object" sprite:nil];
        [self addButtonWithData:@"erase" sprite:[UIImage imageNamed:@"erase.png"]];
        [self addButtonWithData:@"play" sprite:[UIImage imageNamed:@"play.png"]];
        [self addButtonWithData:@"save" sprite:[UIImage imageNamed:@"save.png"]];
        [self addButtonWithData:@"trash" sprite:[UIImage imageNamed:@"trash.png"]];
        [self resizeToFitButtons];
    }
    return self;
}

- (void) updateButtonFromCurrentObject {
    UIImage * sprite = (self.currentObject == nil) ? nil : [self.currentObject getCurrentSprite];
    [self.objectButton setBackgroundImage:sprite forState:UIControlStateNormal];
}

@end
