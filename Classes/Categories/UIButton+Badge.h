//
//  UIButton+Badge.h
//  OutdoorAssistantApplication
//
//  Created by lolaage-A1 on 17/5/9.
//  Copyright © 2017年 Lolaage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Badge)

//显示小红点
- (void)showBadge;

//显示小红点 (redPointEdgeInset 红点偏离右上角的间距调整)
- (void)showBadgeWithRedPointEdgeInset:(CGFloat)redPointEdgeInset;


//隐藏小红点
- (void)hideBadge;

@end
