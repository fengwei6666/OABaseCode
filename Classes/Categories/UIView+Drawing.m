//
//  UIView+Drawing.m
//  GPSAssistant
//
//  Created by 罗亮富 on 14-4-14.
//
//

#import "UIView+Drawing.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation UIView (Drawing)

-(CAShapeLayer *)drawLineFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2 width:(CGFloat)w color:(UIColor *)c
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = w;
   // layer.fillColor = c.CGColor;
    layer.strokeColor = c.CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    layer.path = path.CGPath;
    
    [self.layer addSublayer:layer];
    
    return layer;
}

-(void)removeBorder
{
     CALayer * l = [self layer];
    l.borderWidth = 0.0;
}

-(void)addBorderWidth:(CGFloat)width andColor:(UIColor *)color
{
    CALayer * l = [self layer];
    l.borderWidth = width;
    l.borderColor = color.CGColor;
}

-(void)roundCornerWithRadius:(CGFloat)radius
{
    CALayer * l = [self layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    l.borderWidth = 0.0;
}

-(void)roundCornerWithRadius:(CGFloat)radius corner:(UIRectCorner)corner
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)roundCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    CALayer * l = [self layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    
    l.borderWidth = width;
    if(color)
        l.borderColor = color.CGColor;
    l.masksToBounds = YES;
}

-(CAShapeLayer *)addCircleWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color
{
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:NO];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = width;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
    return layer;
}

- (UIImage *)getScreenShotWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (CAShapeLayer*)dashLineFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2 realLinePoint:(CGFloat)realLinePoint dashLinePoint:(CGFloat)dashLinePoint color:(UIColor*)color lineWidth:(CGFloat)lineWidth
{
    //realLinePoint 单位实线长度  dashLinePoint 单位间隙长度
    CAShapeLayer *layer = [self drawLineFromPoint:p1 toPoint:p2 width:lineWidth color:color];
    layer.lineDashPattern = @[[NSNumber numberWithInteger:realLinePoint],[NSNumber numberWithInteger:dashLinePoint]];

    return layer;
    
}


//创建渐变色Layer
//frame
//colors
//startPoint
//endPoint
//locations
//index
//添加 渐变背景色
- (CAGradientLayer *)addGradientLayerWithframe:(CGRect)frame  colors:(NSArray <UIColor *>*)colors startPoint:(CGPoint)startPoint  endPoint:(CGPoint)endPoint locations:(NSArray <NSNumber *>*)locations  atLayerIndex:(NSUInteger)index
{
    //添加渐变背景色
    CAGradientLayer *colorBacklayer = [[self class] creatGradientLayerColors:colors startPoint:startPoint endPoint:endPoint locations:locations];
    colorBacklayer.frame = frame;
    [self.layer insertSublayer:colorBacklayer atIndex:(unsigned int)index];
    return colorBacklayer;
}


// 创建渐变背景色
+ (CAGradientLayer *)creatGradientLayerColors:(NSArray <UIColor *>*)colors startPoint:(CGPoint)startPoint  endPoint:(CGPoint)endPoint locations:(NSArray <NSNumber *>*)locations
{
    //添加渐变背景色
    CAGradientLayer *colorBacklayer = [CAGradientLayer layer];
    NSMutableArray *colorsArray = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsArray addObject:(__bridge id)(color.CGColor)];
    }
    colorBacklayer.colors = [colorsArray copy];
    colorBacklayer.locations = locations;
    colorBacklayer.startPoint = startPoint;
    colorBacklayer.endPoint = endPoint;
    return colorBacklayer;
}

@end


@implementation UIView (FrameProperty)

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}



@end


@implementation UIView (Shadow)

- (CALayer *)oa_shadowlayer
{
    return objc_getAssociatedObject(self, @selector(oa_shadowlayer));
}

- (void)setOa_shadowlayer:(CALayer *)oa_shadowlayer
{
    objc_setAssociatedObject(self, @selector(oa_shadowlayer), oa_shadowlayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/*
 周边加阴影，并且同时圆角
 */
- (CALayer *)addShadowWithColor:(UIColor *)shadowColor shadowOpacity:(float)shadowOpacity shadowOffset:(CGSize)shadowOffset
              shadowRadius:(CGFloat)shadowRadius cornerRadius:(CGFloat)cornerRadius
{
    if (self.superview == nil) return nil;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = self.layer.bounds;
    float width = rect.size.width;
    float height = rect.size.height;
    float x = rect.origin.x;
    float y = rect.origin.y;
    
    CGPoint topLeft      = rect.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    return [self addShadowWithPath:path.CGPath shadowColor:shadowColor shadowOpacity:shadowOpacity
               shadowOffset:shadowOffset shadowRadius:shadowRadius cornerRadius:cornerRadius roundingCorners:(UIRectCornerAllCorners)];
}

- (CALayer *)addShadowWithPath:(CGPathRef)path shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity
             shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius cornerRadius:(CGFloat)cornerRadius roundingCorners:(UIRectCorner)rectCorner
{
    if (self.superview == nil) return nil;
    
    //这里可能存在一个问题，self removeFromSuperView 的时候 oa_shadowlayer没有移除
    CALayer *shadowLayer = self.oa_shadowlayer;
    if (shadowLayer == nil) {
        shadowLayer = [CALayer layer];
        self.oa_shadowlayer = shadowLayer;
    }
    
    //////// shadow /////////
    shadowLayer.frame = self.layer.frame;
    shadowLayer.shadowColor = shadowColor ? shadowColor.CGColor : [UIColor blackColor].CGColor;
    shadowLayer.shadowOffset = shadowOffset;
    shadowLayer.shadowOpacity = shadowOpacity;
    shadowLayer.shadowRadius = shadowRadius;
    shadowLayer.shadowPath = path;
    
    //////// cornerRadius /////////
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.layer.bounds;
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    maskLayer.path = bPath.CGPath;
    self.layer.mask = maskLayer;
//    self.layer.cornerRadius = cornerRadius;
//    self.layer.masksToBounds = YES;
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [shadowLayer removeFromSuperlayer];
    [self.superview.layer insertSublayer:shadowLayer below:self.layer];
    
    return shadowLayer;
}

@end
