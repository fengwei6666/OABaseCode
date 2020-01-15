//
//  OAPageViewController.h
//  OutdoorAssistantApplication
//
//  Created by wei.feng on 2018/12/13.
//  Copyright © 2018 Lolaage. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OATitlePageControl;
@class OAPageViewController;

//如果需要自定义页面导航控件，需要遵守此协议
@protocol OAPageControlProtocol <NSObject>

@required
//返回当前控件选择的索引位置
- (NSInteger)currentSelectedIndex;

//切换控件选择的索引位置
- (void)selectAtIndex:(NSInteger)index animate:(BOOL)animate;

@optional
//即将开始滑动pageView（到下一页，或者上一页）
- (void)willUpdatePageOffset;

//滑动pageView到下一页，或者上一页的比例（正数表示下一页，负数表示上一页），[-1, 1]
- (void)updatePageOffsetWithFactor:(CGFloat)factor;

@end

@protocol OAPageViewControllerDelegate <NSObject>

- (void)pageView:(OAPageViewController *)pageView willShowChildViewController:(UIViewController *)viewController;
- (void)pageView:(OAPageViewController *)pageView didShowChildViewController:(UIViewController *)viewController;

@end

//容器类ViewController：子ViewController横向并列排布，可以左右滑动切换ViewController。
@interface OAPageViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, readonly) UIView *pageView;//子ViewController的容器view
@property (nonatomic, readonly) UIControl<OAPageControlProtocol> *pageControl;//页面选择控制view。默认使用 OATitlePageControl
@property (nonatomic, strong) NSArray<UIViewController *> *pages;//子ViewController
@property (nonatomic, readonly) NSInteger currentIndex;//当前显示的页面索引
@property (nonatomic, readonly) BOOL useChildRightNavigationItem;
@property (nonatomic) BOOL disablePageScroll;//禁用滑动切换ViewController
@property (nonatomic, weak) id<OAPageViewControllerDelegate> delegate;

//显示指定索引位置的ViewController
- (void)changePageAtIndex:(NSUInteger)index animate:(BOOL)animate;

@end

typedef NS_ENUM(NSUInteger, OATitlePageControlLayout) {
    OATitlePageControlLayout_Fill,  ///< 所有title所占用的宽度是一样的，所有title填充完整个control
    OATitlePageControlLayout_Auto,  ///< 自动根据title的长度布局，保持每个title之前的间隔距离相等
};

//滑块的样式
typedef NS_ENUM(NSUInteger, OATitlePageSliderStyle) {
    OATitlePageSliderStyle_TitleColor,  ///< title下面一条下划线的样式
    OATitlePageSliderStyle_TitleBackgroudColor, ///< title背景色高亮的样式
};

@protocol OATitlePageControlDelegate <NSObject>

//是否允许选中索引位置
- (BOOL)pageControl:(OATitlePageControl *)pageControl shouldSelectAtIndex:(NSInteger)index;

@end

//直接使用[OAPageViewController.childViewControllers valueForKey:@"title"]作为切换卡的控件
@interface OATitlePageControl : UIControl<OAPageControlProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic) OATitlePageControlLayout titleLayout;
@property (nonatomic) OATitlePageSliderStyle sliderStyle;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, strong) UIColor *normalColor;//未被选中的title的颜色，默认 kMainContentColor
@property (nonatomic, strong) UIColor *selectedColor;//被选中的title的颜色，默认使用APP_COLOR
@property (nonatomic, strong) UIColor *sliderColor; //滑块的颜色，如果不设置默认使用selectedColor
@property (nonatomic, strong) UIFont *normalTitleFont;
@property (nonatomic, strong) UIFont *selectedTitleFont;
@property (nonatomic, weak) id<OATitlePageControlDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
