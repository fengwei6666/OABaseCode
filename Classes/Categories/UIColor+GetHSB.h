//
//  UIColor+GetHSB.h
//  ILColorPickerExample
//
//  Created by Jon Gilkison on 9/2/11.
//  Copyright 2011 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct {
    float hue;
    float saturation;
    float brightness;
} HSBType;

@interface UIColor(GetHSB)

@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 rgbHex;
@property (nonatomic, readonly) UInt32 rgbaHex;

//@property (nonatomic,assign) float UIColorWidth;
//@property (nonatomic,assign) float UIColorHeight;
//@property (nonatomic,assign) float UIColorAllHeight;


-(HSBType)HSB;
- (NSString *)hexStringFromColor;
- (NSString *)hexString;
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

/**
 给颜色添加一个遮罩颜色

 @param maskColor 遮罩颜色

 @return
 */
- (UIColor *)appendMaskRGBColor:(UIColor *)maskColor;

/**
 在原有颜色的基础上按比例衰减（放大）

 @param factor 衰减比例

 @return 
 */
- (UIColor *)colorByMutilFactor:(CGFloat)factor;


//判断颜色是否相同
- (BOOL)isEqualToColor:(UIColor*)secondColor;

//判断颜色是否相同
+ (BOOL)oneColor:(UIColor *)oneColor isEqualToColor:(UIColor*)secondColor;
@end

