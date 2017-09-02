//
//  NSObject+UIButton_UserData.m
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "UIButton+UserData.h"
#import <objc/runtime.h>

static void * UIButtonUserDataKey;
@implementation UIButton (UIButton_UserData)
- (NSObject*) userData {
    return objc_getAssociatedObject(self, &UIButtonUserDataKey);
}
- (void)setUserData:(NSObject *)userData {
     objc_setAssociatedObject(self, &UIButtonUserDataKey, userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
