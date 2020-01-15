//
//  UITextField+OADelete.m
//  OutdoorAssistantApplication
//
//  Created by Lola001 on 2019/3/7.
//  Copyright © 2019年 Lolaage. All rights reserved.
//

#import "UITextField+OADelete.h"
#import <objc/runtime.h>

@implementation UITextField (OADelete)

+ (void)load {
    
    Method systemMethod = class_getInstanceMethod([self class], @selector(deleteBackward));
    Method customMethod = class_getInstanceMethod([self class], @selector(oa_deleteBackward));
    method_exchangeImplementations(systemMethod, customMethod);
}

- (void)oa_deleteBackward {
    
    if (self.clickDeleteHandler) {
        self.clickDeleteHandler(self);
    }
    
    [self oa_deleteBackward];
}

- (void)setClickDeleteHandler:(void (^)(UITextField *tf))clickDeleteHandler {
    
    objc_setAssociatedObject(self, @selector(clickDeleteHandler), clickDeleteHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITextField *tf))clickDeleteHandler {
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
