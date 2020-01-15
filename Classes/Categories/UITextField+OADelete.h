//
//  UITextField+OADelete.h
//  OutdoorAssistantApplication
//
//  Created by Lola001 on 2019/3/7.
//  Copyright © 2019年 Lolaage. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 该类别主要是 获取textfield点击删除键的事件
 */
@interface UITextField (OADelete)

// 点击删除键回调
@property (nonatomic, copy) void(^clickDeleteHandler)(UITextField *tf);

@end

