//
//  UIView+OACreate.m
//  OutdoorAssistantApplication
//
//  Created by lotus on 2018/6/25.
//  Copyright © 2018年 Lolaage. All rights reserved.
//

#import "UIView+OACreate.h"

@implementation UIView (OACreate)

@end

@implementation UIButton (OAButtonCreate)

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
                 isSizeTofit:(BOOL)sizeTofit{

    UIButton *button = [[self class] buttonWithType:buttonType];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = font;

    if ([bgImage isKindOfClass:[NSString class]]) {
        [button setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    }else if ([bgImage isKindOfClass:[UIImage class]]){
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    }

    if ([image isKindOfClass:[NSString class]]) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }else if ([image isKindOfClass:[UIImage class]]){
        [button setImage:image forState:UIControlStateNormal];
    }

    if (bgColor == nil){
        button.backgroundColor = [UIColor clearColor];
    } else {
        button.backgroundColor = bgColor;
    }

    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    button.tag = tag;

    if (sizeTofit) [button sizeToFit];

    return button;
}

@end

@implementation UILabel (OALabelCreate)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
              textAlignment:(NSTextAlignment)textAlignment
                       font:(UIFont *)font
              numberOfLines:(NSInteger)numberOfLines
                    bgColor:(UIColor *)bgColor
                        tag:(NSInteger)tag
                isSizeTofit:(BOOL)sizeTofit{
    UILabel *label = [[[self class] alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = font;
    label.numberOfLines = numberOfLines;
    if (bgColor == nil) {
        label.backgroundColor = [UIColor clearColor];
    }else {
        label.backgroundColor = bgColor;
    }

    label.tag = tag;

    if (sizeTofit) [label sizeToFit];
    return label;
}

@end








