//
//  ModeSelectionPopup.h
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemSelectionPopup.h"

@interface ModeSelectionPopup : ItemSelectionPopup
@property (weak) GameObject * currentObject;
- (void) updateButtonFromCurrentObject;
@end
