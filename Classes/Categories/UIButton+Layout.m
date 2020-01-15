//
//  UIButton+Layout.m
//  OutdoorAssistantApplication
//
//  Created by Weifeng on 2016/12/23.
//  Copyright © 2016年 Lolaage. All rights reserved.
//

#import "UIButton+Layout.h"

@implementation UIButton (Layout)

- (void)relayoutImageTopTextBottom
{
    [self relayoutImageTopTextBottomWithSpace:20];
}

- (void)relayoutImageTopTextBottomWithSpace:(CGFloat)space
{
    if (self.imageView.image && [self.titleLabel.text length] > 0)
    {
        /*  调整图片和文字的布局 */
        CGSize imageSize = self.imageView.image.size;
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height-space/2.0, 0, 0, -titleSize.width);
        UIEdgeInsets titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height-space/2.0, 0);
        [self setImageEdgeInsets:imageEdgeInsets];
        [self setTitleEdgeInsets:titleEdgeInsets];
    }
}

- (void)relayoutTextLeftImageRight
{
    [self relayoutTextLeftImageRightWithSpace:20];
}

- (void)relayoutTextLeftImageRightWithSpace:(CGFloat)space
{
    if (self.imageView.image && [self.titleLabel.text length] > 0)
    {
        /*  调整图片和文字的布局 */
        CGSize imageSize = self.imageView.image.size;
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + space/2, 0, 0);
        UIEdgeInsets titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageSize.width + space/2);
        [self setImageEdgeInsets:imageEdgeInsets];
        [self setTitleEdgeInsets:titleEdgeInsets];
    }
}

@end
