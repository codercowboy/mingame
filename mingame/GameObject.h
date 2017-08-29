//
//  GameObject.h
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GameObject : NSObject

@property CGPoint position;
@property (strong) UIImage * sprite;

- (void) setUIImageBackgroundColor:(UIColor *)color;

@end
