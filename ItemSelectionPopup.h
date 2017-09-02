//
//  ItemSelectionPopup.h
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemSelectionPopup;

@protocol ItemSelectionPopupButtonDelegate
- (void) handleButtonClickData:(NSObject *)data selectionPopup:(ItemSelectionPopup *)selectionPopup;
@end

@interface ItemSelectionPopup : UIView
@property int buttonX;
@property int buttonY;
@property int maxX;
@property int maxY;
@property (weak) id<ItemSelectionPopupButtonDelegate> buttonDelegate;
- (UIButton *) addButtonWithData:(NSObject*)data sprite:(UIImage*)sprite;
- (void) resizeToFitButtons;
- (void) moveToNextButtonRow;
@end
