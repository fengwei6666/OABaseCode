//
//  UIView+Drawing.h
//  GPSAssistant
//
//  Created by 罗亮富 on 14-4-14.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Drawing)
/**
 *  在 UIView 上画一条线, 通过在 Layer 上添加一个 CAShapeLayer 实现画线
 *
 *  @param p1 起点
 *  @param p2 终点
 *  @param w  线宽
 *  @param c  颜色
 *
 *  @return 画线的 CAShapeLayer
 */
-(CAShapeLayer *)drawLineFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2 width:(CGFloat)w color:(UIColor *)c;

-(void)roundCornerWithRadius:(CGFloat)radius;

-(void)roundCornerWithRadius:(CGFloat)radius corner:(UIRectCorner)corner;

-(void)roundCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;

-(CAShapeLayer *)addCircleWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color;

-(void)addBorderWidth:(CGFloat)width andColor:(UIColor *)color;

-(void)removeBorder;

- (UIImage *)getScreenShotWithSize:(CGSize)size;

// 画虚线  realLinePoint : 实线长度， dashLinePoint : 虚线长度   //zhouhuan add
- (CAShapeLayer*)dashLineFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2 realLinePoint:(CGFloat)realLinePoint dashLinePoint:(CGFloat)dashLinePoint color:(UIColor*)color lineWidth:(CGFloat)lineWidth;


//frame         layer的frame
//colors        渐变色的颜色
//startPoint    开始位置 x 和y 的取值范围是0到1
//endPoint      结束位置 x 和y 的取值范围是0到1
//locations     渐变色中间点的位置  NSNumber取值范围是0到1
//index         layer 的在view 中的index的位置
//添加 渐变色layer
- (CAGradientLayer *)addGradientLayerWithframe:(CGRect)frame  colors:(NSArray <UIColor *>*)colors startPoint:(CGPoint)startPoint  endPoint:(CGPoint)endPoint locations:(NSArray <NSNumber *>*)locations  atLayerIndex:(NSUInteger)index;


//colors        渐变色的颜色
//startPoint    开始位置 x 和y 的取值范围是0到1
//endPoint      结束位置 x 和y 的取值范围是0到1
//locations     渐变色中间点的位置 NSNumber的取值范围是0到1
//添加 渐变色layer
// 创建渐变背景色
+ (CAGradientLayer *)creatGradientLayerColors:(NSArray <UIColor *>*)colors startPoint:(CGPoint)startPoint  endPoint:(CGPoint)endPoint locations:(NSArray <NSNumber *>*)locations;

@end


@interface UIView (FrameProperty)

@property (readonly) CGFloat x;        ///< Shortcut for frame.origin.x.
@property (readonly) CGFloat y;         ///< Shortcut for frame.origin.y

@end


@interface UIView (Shadow)

@property (nonatomic, strong) CALayer *oa_shadowlayer;

//同时加阴影和圆角
- (CALayer *)addShadowWithColor:(UIColor *)shadowColor
             shadowOpacity:(float)shadowOpacity
              shadowOffset:(CGSize)shadowOffset
              shadowRadius:(CGFloat)shadowRadius
              cornerRadius:(CGFloat)cornerRadius;

- (CALayer *)addShadowWithPath:(CGPathRef )path shadowColor:(UIColor *)shadowColor
            shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset
             shadowRadius:(CGFloat)shadowRadius cornerRadius:(CGFloat)cornerRadius
          roundingCorners:(UIRectCorner)rectCorner;

@end

