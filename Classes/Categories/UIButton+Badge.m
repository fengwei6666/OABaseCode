//
//  UIButton+Badge.m
//  OutdoorAssistantApplication
//
//  Created by lolaage-A1 on 17/5/9.
//  Copyright © 2017年 Lolaage. All rights reserved.
//

#import "UIButton+Badge.h"

#define btnTag 35734
@implementation UIButton (Badge)

//显示小红点
- (void)showBadge
{
    [self showBadgeWithRedPointEdgeInset:0];
}

- (void)showBadgeWithRedPointEdgeInset:(CGFloat)redPointEdgeInset
{
    //移除之前的小红点
    [self removeBadge];
    
    //新建小红点
    CGFloat badgeViewWH = 8;
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = btnTag;
    badgeView.layer.cornerRadius = badgeViewWH * 0.5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    
    //确定小红点的位置
    badgeView.frame = CGRectMake(self.bounds.size.width - 3 + redPointEdgeInset, 4 - redPointEdgeInset, badgeViewWH, badgeViewWH);
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadge
{
    //移除小红点
    [self removeBadge];
}

//移除小红点
- (void)removeBadge
{
    //按照tag值进行移除
    for (UIView *subView in self.subviews)
    {
        if (subView.tag == btnTag) {
            [subView removeFromSuperview];
        }
    }
}

@end
