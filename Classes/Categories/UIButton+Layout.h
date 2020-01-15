//
//  UIButton+Layout.h
//  OutdoorAssistantApplication
//
//  Created by Weifeng on 2016/12/23.
//  Copyright © 2016年 Lolaage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Layout)

- (void)relayoutImageTopTextBottom;
- (void)relayoutImageTopTextBottomWithSpace:(CGFloat)space;

- (void)relayoutTextLeftImageRight;
- (void)relayoutTextLeftImageRightWithSpace:(CGFloat)space;

@end
