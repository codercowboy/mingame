//
//  ItemSelectionPopup.m
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "ItemSelectionPopup.h"
#import "GameRenderer.h"
#import "UIButton+UserData.h"

@implementation ItemSelectionPopup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxX = 0;
        self.maxY = 0;
        self.buttonX = 10;
        self.buttonY = 10;
    }
    return self;
}

- (UIButton *) addButtonWithData:(NSObject*)data sprite:(UIImage*)sprite {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userData = data;
    button.frame = CGRectMake(self.buttonX, self.buttonY, 30, 30);
    self.maxX = MAX(self.maxX, self.buttonX);
    self.maxY = MAX(self.maxY, self.buttonY);
    self.buttonX += 40;
    if (sprite != nil) {
        [button setBackgroundImage:sprite forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void) handleButtonClick:(UIButton*)button {
    [self.buttonDelegate handleButtonClickData:button.userData selectionPopup:self];
}

- (void) moveToNextButtonRow {
    self.buttonY += 40;
    self.buttonX = 10;
}

- (void) resizeToFitButtons {
    self.frame = CGRectMake(0, 0, self.maxX + 40, self.maxY + 40);
}

@end
