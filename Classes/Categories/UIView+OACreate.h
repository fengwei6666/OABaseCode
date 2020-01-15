//
//  UIView+OACreate.h
//  OutdoorAssistantApplication
//
//  Created by lotus on 2018/6/25.
//  Copyright © 2018年 Lolaage. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 快速创建控件类
 */
@interface UIView (OACreate)

@end

@interface UIButton (OAButtonCreate)
/**
 创建button
 */
+ (UIButton *)buttonWithType:(UIButtonType)buttonType
                       frame:(CGRect)frame
                       title:(NSString *)title
                  titleColor:(UIColor *)color
                   titleFont:(UIFont *)font
                     bgImage:(id)bgImage
                       image:(id)image
                     bgColor:(UIColor *)bgColor
                      target:(id)target
                      action:(SEL)action
                         tag:(NSInteger)tag
                 isSizeTofit:(BOOL)sizeTofit;
@end

@interface UILabel (OALabelCreate)
/**
 快速创建label
 */
+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
              textAlignment:(NSTextAlignment)textAlignment
                       font:(UIFont *)font
              numberOfLines:(NSInteger)numberOfLines
                    bgColor:(UIColor *)bgColor
                        tag:(NSInteger)tag
                isSizeTofit:(BOOL)sizeTofit;
@end












