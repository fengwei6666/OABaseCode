//
//  OAPageViewController.m
//  OutdoorAssistantApplication
//
//  Created by wei.feng on 2018/12/13.
//  Copyright © 2018 Lolaage. All rights reserved.
//

#import "OAPageViewController.h"
#import "Masonry.h"
#import "UIFont+style.h"

@interface OAPageViewController ()

@property (nonatomic, strong) UIScrollView *_pageScrollView;

@end

@implementation OAPageViewController
{
    OATitlePageControl *_pageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _useChildRightNavigationItem = YES;
    
    [self.pageControl addTarget:self action:@selector(pageControlValueDidChanged:) forControlEvents:(UIControlEventValueChanged)];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadPageViewController];
    });
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self._pageScrollView];
    [self.view addSubview:self.pageControl];
    
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.topLayoutGuide ? self.mas_topLayoutGuideBottom : self.view);
        }
    }];
    
    [__pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.pageControl.mas_bottom);
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self reloadScrollViewLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self currentShowedVC] beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self currentShowedVC] endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self currentShowedVC] beginAppearanceTransition:NO animated:animated];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[self currentShowedVC] endAppearanceTransition];
    
    [super viewDidDisappear:animated];
}

#pragma mark - event response

- (void)pageControlValueDidChanged:(UIView<OAPageControlProtocol> *)sender
{
    [self changePageAtIndex:[sender currentSelectedIndex] animate:YES];
}

#pragma mark - getter

- (UIControl<OAPageControlProtocol> *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[OATitlePageControl alloc] init];
    }
    return _pageControl;
}

- (UIView *)pageView
{
    return __pageScrollView;
}

- (UIScrollView *)_pageScrollView
{
    if (__pageScrollView == nil) {
        __pageScrollView = [[UIScrollView alloc] init];
        __pageScrollView.backgroundColor = self.view.backgroundColor;
        __pageScrollView.showsVerticalScrollIndicator = NO;
        __pageScrollView.showsHorizontalScrollIndicator = NO;
        __pageScrollView.pagingEnabled = YES;
        __pageScrollView.delegate = self;
        __pageScrollView.bounces = NO;
        __pageScrollView.scrollsToTop = NO;
        __pageScrollView.scrollEnabled = !_disablePageScroll;
        __pageScrollView.canCancelContentTouches = NO;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([__pageScrollView respondsToSelector:NSSelectorFromString(@"setShouldIgnoreScrollingAdjustment:")]) {
            [__pageScrollView performSelector:NSSelectorFromString(@"setShouldIgnoreScrollingAdjustment:") withObject:@(YES)];
        }
        #pragma clang diagnostic pop

        if (@available(iOS 11.0, *)) {
            __pageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        // 当是侧滑手势的时候设置scrollview需要此手势失效即可
        NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
        for (UIGestureRecognizer *gesture in gestureArray) {
            if ([gesture isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                [__pageScrollView.panGestureRecognizer requireGestureRecognizerToFail:gesture];
                break;
            }
        }
    }
    return __pageScrollView;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (UIViewController *)currentShowedVC
{
    if (_currentIndex >= 0 && _currentIndex < [_pages count]) {
        UIViewController *vc = _pages[_currentIndex];
        if (vc.isViewLoaded && vc.view.superview) {
            return vc;
        }
    }
    return nil;
}

#pragma mark - setter

- (void)setPages:(NSArray<UIViewController *> *)pages
{
    _pages = pages;
    
    if (self.isViewLoaded) {
        [self reloadPageViewController];
    }
}

- (void)setDisablePageScroll:(BOOL)disablePageScroll
{
    _disablePageScroll = disablePageScroll;
    
    __pageScrollView.scrollEnabled = !disablePageScroll;
}

#pragma mark - UIScrollViewDelegate

static BOOL handleDrag = NO;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == __pageScrollView) {
        handleDrag = YES;
        
        if ([self.pageControl respondsToSelector:@selector(willUpdatePageOffset)]) {
            [self.pageControl willUpdatePageOffset];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == __pageScrollView) {
        if (handleDrag && [self.pageControl respondsToSelector:@selector(updatePageOffsetWithFactor:)] && scrollView.bounds.size.width > 0) {
            CGFloat offset = scrollView.contentOffset.x/scrollView.bounds.size.width;
            [self.pageControl updatePageOffsetWithFactor:offset-_currentIndex];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == __pageScrollView) {
        if (decelerate) {
            scrollView.userInteractionEnabled = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (__pageScrollView == scrollView) {
        handleDrag = NO;
        scrollView.userInteractionEnabled = YES;
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        
        if (index != _currentIndex) {
            //切换到新的childViewController
            [self changePageAtIndex:index animate:NO];
            
            //控制器也切换到响应的索引位置
            [self.pageControl selectAtIndex:index animate:YES];
        }
    }
}

#pragma mark - privite

- (void)reloadPageViewController
{
    //先移除已经存在的 childViewControllers
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [__pageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _pages = self.pages;
    if (_pages > 0) {
        //重新配置 OATitlePageControl 数据源
        if ([self.pageControl isMemberOfClass:[OATitlePageControl class]]) {
            NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:[_pages count]];
            [_pages enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *title = obj.title ? : @"无标题";
                [titles addObject:title];
            }];
            [(OATitlePageControl *)self.pageControl setItems:titles];
        }
        
        //再重新添加 childViewControllers
        [_pages enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:obj];
        }];
        
        //修正scrollView.contentSize
        [self reloadScrollViewLayout];
        
        //修正索引
        if (_currentIndex < 0 || _currentIndex >= [_pages count]) {
            _currentIndex = 0;
        }
        
        //显示索引位置的childViewController
        [self changePageAtIndex:_currentIndex animate:NO];
    }
}

- (void)reloadScrollViewLayout
{
    __pageScrollView.contentSize = CGSizeMake(CGRectGetWidth(__pageScrollView.bounds) * [_pages count], CGRectGetHeight(__pageScrollView.bounds));
    
    [_pages enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isViewLoaded && obj.view.superview) {
            [self fixFrameForChildViewControllerAtIndex:idx];
        }
    }];
    
    CGRect frame = __pageScrollView.frame;
    frame.origin.x = frame.size.width * _currentIndex;
    frame.origin.y = 0;
    [__pageScrollView scrollRectToVisible:frame animated:NO];
}

- (void)reloadNavigationItems
{
    if (self.useChildRightNavigationItem) {
        UIViewController *childVC = _pages[_currentIndex];
        self.navigationItem.rightBarButtonItems = childVC.navigationItem.rightBarButtonItems;
    }
}

#pragma mark - public

- (void)changePageAtIndex:(NSUInteger)index animate:(BOOL)animate
{
    if (index >= 0 && index < [_pages count]) {
        
        UIViewController *oldViewController = (_currentIndex == index) ? nil : _pages[_currentIndex];
        UIViewController *newViewController = _pages[index];
        
        if (newViewController){
            if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:willShowChildViewController:)]) {
                [self.delegate pageView:self willShowChildViewController:newViewController];
            }
            
            if (newViewController.view.superview == nil){
                
                UIViewController *controller = _pages[index];
                if (controller == nil) return;
                [__pageScrollView addSubview:controller.view];
            }
            
            [self fixFrameForChildViewControllerAtIndex:index];

            [oldViewController beginAppearanceTransition:NO animated:YES];
            [newViewController beginAppearanceTransition:YES animated:YES];
            
            CGRect frame = __pageScrollView.frame;
            frame.origin.x = frame.size.width * index;
            frame.origin.y = 0;
            
            [__pageScrollView scrollRectToVisible:frame animated:animate];
            _currentIndex = index;
            self.automaticallyAdjustsScrollViewInsets = newViewController.automaticallyAdjustsScrollViewInsets;
            
            [oldViewController endAppearanceTransition];
            [newViewController endAppearanceTransition];
            
            [self reloadNavigationItems];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:didShowChildViewController:)]) {
                [self.delegate pageView:self didShowChildViewController:newViewController];
            }
            
            [self.pageControl selectAtIndex:index animate:animate];
        }
    }
}

- (void)fixFrameForChildViewControllerAtIndex:(NSUInteger)index
{
    UIViewController *viewController = _pages[index];
    
    if (viewController.view.superview){
        
        [viewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(__pageScrollView);
            make.top.equalTo(__pageScrollView);
            make.left.mas_equalTo(index * CGRectGetWidth(__pageScrollView.bounds));
        }];
    }
}

@end


@implementation OATitlePageControl
{
    __weak UILabel *_lastSelect;
    
    CGRect _preRect;
    CGRect _curRect;
    CGRect _nextRect;
}

@synthesize selectedIndex = _selectedIndex;
@synthesize normalColor = _normalColor;
@synthesize selectedColor = _selectedColor;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self.collectionView insertSubview:self.sliderView atIndex:0];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _collectionView.frame = self.bounds;
}

#pragma mark - getter

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = ~UIViewAutoresizingNone;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"__title_cell_acv"];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (UIView *)sliderView
{
    if (_sliderView == nil) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = self.sliderColor ? : self.selectedColor;
        _sliderView.layer.cornerRadius = 1;
    }
    return _sliderView;
}

- (UIColor *)normalColor
{
    if (_normalColor == nil) {
        _normalColor = [UIColor colorWithWhite:68/255.0 alpha:1];
    }
    return _normalColor;
}

- (UIColor *)selectedColor
{
    if (_selectedColor == nil) {
        _selectedColor = [UIColor colorWithRed:25/255.0 green:186/255.0 blue:29/255.0 alpha:1];
    }
    return _selectedColor;
}

#pragma mark - setter

- (void)setItems:(NSArray *)items
{
    _items = items;
    _selectedIndex = 0;
    
    [_collectionView reloadData];
    [_collectionView setContentOffset:CGPointZero];    
}

- (void)setTitleLayout:(OATitlePageControlLayout)titleLayout
{
    if (_titleLayout != titleLayout) {
        _titleLayout = titleLayout;
        
        [_collectionView reloadData];
    }
}

- (void)setSliderStyle:(OATitlePageSliderStyle)sliderStyle
{
    if (_sliderStyle != sliderStyle) {
        _sliderStyle = sliderStyle;
        
        [_collectionView reloadData];
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    
    [_collectionView reloadData];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    
    [_collectionView reloadData];
    
    if (_sliderColor == nil) {
        _sliderView.backgroundColor = selectedColor;
    }
}

- (void)setSliderColor:(UIColor *)sliderColor
{
    _sliderColor = sliderColor;
    _sliderView.backgroundColor = sliderColor;
}

- (void)setNormalTitleFont:(UIFont *)normalTitleFont
{
    _normalTitleFont = normalTitleFont;
    [_collectionView reloadData];
}

- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont
{
    _selectedTitleFont = selectedTitleFont;
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionView dataSource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"__title_cell_acv" forIndexPath:indexPath];
    UILabel *titleLabel = [cell.contentView viewWithTag:0x676];
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] initWithFrame:cell.bounds];
        titleLabel.tag = 0x676;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = CGRectGetWidth([UIScreen mainScreen].bounds) < 330 ? APP_DEFAULT_FONT(14) : APP_DEFAULT_FONT(16);
        titleLabel.autoresizingMask = ~UIViewAutoresizingNone;
        [cell.contentView addSubview:titleLabel];
    }
    
    if (indexPath.row < [self.items count]) {
        titleLabel.text = self.items[indexPath.row];
        
        BOOL isSelectedCell = (indexPath.row == _selectedIndex);
        titleLabel.textColor = isSelectedCell ? self.selectedColor : self.normalColor;
        UIFont *font = titleLabel.font;
        if (isSelectedCell) {
            font = self.selectedTitleFont ? : [font fontWithBold];
        }else{
            font = self.normalTitleFont ? : [font fontWithNormal];
        }
        titleLabel.font = font;

        if (isSelectedCell) {
            _lastSelect = titleLabel;
            
            switch (_sliderStyle) {
                case OATitlePageSliderStyle_TitleColor:
                    {
                        CGSize size = [titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : titleLabel.font} context:nil].size;
                        CGFloat width = MAX(30, ceil(size.width));
                        self.sliderView.frame = CGRectMake(cell.center.x - width/2, CGRectGetMaxY(cell.frame)-2, width, 2);
                    }
                    break;
                case OATitlePageSliderStyle_TitleBackgroudColor:
                    {
                        CGRect rect = CGRectMake(cell.frame.origin.x + 8, cell.center.y - 18, cell.bounds.size.width - 16, 36);
                        self.sliderView.frame = rect;
                        self.sliderView.layer.cornerRadius = 4;
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    if (_sliderStyle == OATitlePageSliderStyle_TitleBackgroudColor) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.superview sendSubviewToBack:self.sliderView];
        });
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 0;
    if (_titleLayout == OATitlePageControlLayout_Auto) {
        NSString *string = @"无标题";
        if (indexPath.row < [self.items count]) {
            string = self.items[indexPath.row];
        }
        
        CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
        width = ceil(size.width) + 20;
    }else{
        if ([self.items count] > 0) {
            width = (int)(CGRectGetWidth(collectionView.bounds)/[self.items count]);
        }
    }
    
    return CGSizeMake(width, CGRectGetHeight(collectionView.bounds));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BOOL shouldSelect = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(pageControl:shouldSelectAtIndex:)]) {
        shouldSelect = [_delegate pageControl:self shouldSelectAtIndex:indexPath.row];
    }
    
    if (!shouldSelect) {
        return;
    }
    
    if (_selectedIndex != indexPath.row) {
        [self selectAtIndex:indexPath.row animate:YES];
        [self sendActionsForControlEvents:(UIControlEventValueChanged)];
    }
}

#pragma mark - OAPageSegmentViewProtocol

- (NSInteger)currentSelectedIndex
{
    return self.selectedIndex;
}

- (void)selectAtIndex:(NSInteger)index animate:(BOOL)animate
{
    if (index < 0 || index >= [self.items count]) {
        return;
    }
    
    if ([_collectionView numberOfSections] > 0) {
        if ([_collectionView numberOfItemsInSection:0] > index) {

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
            if (cell == nil) {
                return;
            }
            _lastSelect.font = self.normalTitleFont ? : [_lastSelect.font fontWithNormal];
            [_lastSelect setTextColor:self.normalColor];
            UILabel *label = (UILabel *)[cell viewWithTag:0x676];
            [label setTextColor:self.selectedColor];
            label.font = self.selectedTitleFont ? : self.normalTitleFont ? : [label.font fontWithBold];
            _lastSelect = label;
            
            _selectedIndex = index;
            CGRect rect = cell.frame;
            switch (_sliderStyle) {
                case OATitlePageSliderStyle_TitleColor:
                    {
                        UILabel *titleLabel = [cell.contentView viewWithTag:0x676];
                        CGSize size = [titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : titleLabel.font} context:nil].size;
                        CGFloat width = MAX(40, ceil(size.width));
                        rect = CGRectMake(CGRectGetMidX(rect) - width/2, CGRectGetMaxY(rect) - 2, width, 2);
                    }
                    break;
                case OATitlePageSliderStyle_TitleBackgroudColor:
                    rect = CGRectMake(cell.frame.origin.x + 8, cell.center.y - 18, cell.bounds.size.width - 16, 36);
                    break;
                default:
                    break;
            }

            [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
            
            if (animate) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.sliderView.frame = rect;
                } completion:^(BOOL finished) {
                    //
                }];
            }else{
                self.sliderView.frame = rect;
            }
        }
    }
}

- (void)willUpdatePageOffset
{
    if (_collectionView.contentSize.width > 0) {
        if ([_collectionView numberOfSections] > 0 && [_collectionView numberOfItemsInSection:0] > _selectedIndex) {
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
            _curRect = cell.frame;
        }

        if (_selectedIndex > 0 && [_collectionView numberOfSections] > 0 && [_collectionView numberOfItemsInSection:0] > _selectedIndex-1) {
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex-1 inSection:0]];
            _preRect = cell.frame;
        }else{
            _preRect = _curRect;
        }

        if (_selectedIndex + 1 < [self.items count] && [_collectionView numberOfSections] > 0 && [_collectionView numberOfItemsInSection:0] > _selectedIndex + 1) {
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex+1 inSection:0]];
            _nextRect = cell.frame;
        }else{
            _nextRect = _curRect;
        }
    }
}

- (void)updatePageOffsetWithFactor:(CGFloat)factor
{
    if (_sliderView.superview) {
        CGPoint center = _sliderView.center;
        if (factor > 0) {
            center.x = CGRectGetMidX(_curRect) + (CGRectGetWidth(_curRect)/2 + CGRectGetWidth(_nextRect)/2) * MIN(factor, 1);
        }else{
            center.x = CGRectGetMidX(_curRect) + (CGRectGetWidth(_curRect)/2 + CGRectGetWidth(_preRect)/2) * MAX(factor, -1);
        }
        _sliderView.center = center;
    }
}

@end
