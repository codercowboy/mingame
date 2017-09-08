//
//  LevelEditorViewController.h
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObjectSelectionPopup.h"
#import "ModeSelectionPopup.h"
#import "GameLevel.h"

@interface LevelEditorViewController : UIViewController <ItemSelectionPopupButtonDelegate>

@property (strong) IBOutlet UIImageView * imageView;
@property (strong) GameLevel * level;

@end
