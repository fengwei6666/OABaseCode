//
//  UIColor+GetHSB.m
//  ILColorPickerExample
//
//  Created by Jon Gilkison on 9/2/11.
//  Copyright 2011 Interfacelab LLC. All rights reserved.
//

#import "UIColor+GetHSB.h"

@implementation UIColor(GetHSB)



-(HSBType)HSB
{
    HSBType hsb;
    
    hsb.hue=0;
    hsb.saturation=0;
    hsb.brightness=0;
    
    CGColorSpaceModel model=CGColorSpaceGetModel(CGColorGetColorSpace([self CGColor]));
    
    if ((model==kCGColorSpaceModelMonochrome) || (model==kCGColorSpaceModelRGB))
    {
        const CGFloat *c = CGColorGetComponents([self CGColor]);  
        
        float x = fminf(c[0], c[1]);
        x = fminf(x, c[2]);
        
        float b = fmaxf(c[0], c[1]);
        b = fmaxf(b, c[2]);
        
        if (b == x) 
        {
            hsb.hue=0;
            hsb.saturation=0;
            hsb.brightness=b;
        }
        else
        {
            float f = (c[0] == x) ? c[1] - c[2] : ((c[1] == x) ? c[2] - c[0] : c[0] - c[1]);
            int i = (c[0] == x) ? 3 : ((c[1] == x) ? 5 : 1);
            
            hsb.hue=((i - f /(b - x))/6);
            hsb.saturation=(b - x)/b;
            hsb.brightness=b;
        }
    }
    
    return hsb;
}


- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)colorSpaceString {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelUnknown:
            return @"kCGColorSpaceModelUnknown";
        case kCGColorSpaceModelMonochrome:
            return @"kCGColorSpaceModelMonochrome";
        case kCGColorSpaceModelRGB:
            return @"kCGColorSpaceModelRGB";
        case kCGColorSpaceModelCMYK:
            return @"kCGColorSpaceModelCMYK";
        case kCGColorSpaceModelLab:
            return @"kCGColorSpaceModelLab";
        case kCGColorSpaceModelDeviceN:
            return @"kCGColorSpaceModelDeviceN";
        case kCGColorSpaceModelIndexed:
            return @"kCGColorSpaceModelIndexed";
        case kCGColorSpaceModelPattern:
            return @"kCGColorSpaceModelPattern";
        default:
            return @"Not a valid color space";
    }
}

- (BOOL)canProvideRGBComponents {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (CGFloat)red {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)green {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

- (CGFloat)blue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

- (CGFloat)white {
    NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}
- (CGFloat)alpha {
    return 1.0;
}

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r,g,b,a;
    
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelMonochrome:
            r = g = b = components[0];
            a = components[1];
            break;
        case kCGColorSpaceModelRGB:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
        default:	// We don't know how to handle this model
            return NO;
    }
    
    if (red) *red = r;
    if (green) *green = g;
    if (blue) *blue = b;
    if (alpha) *alpha = a;
    
    return YES;
}

- (UInt32)rgbHex {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbHex");
    
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
    
    r = MIN(MAX(self.red, 0.0f), 1.0f);
    g = MIN(MAX(self.green, 0.0f), 1.0f);
    b = MIN(MAX(self.blue, 0.0f), 1.0f);
    
    return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)));
}
- (UInt32)rgbaHex {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbaHex");
    
    CGFloat r,g,b,a;
    if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
    
    r = MIN(MAX(self.red, 0.0f), 1.0f);
    g = MIN(MAX(self.green, 0.0f), 1.0f);
    b = MIN(MAX(self.blue, 0.0f), 1.0f);
    a = MIN(MAX(self.alpha, 0.0f), 1.0f);
    
//    return (((int)roundf(r * 255)) << 24)
//    | (((int)roundf(g * 255)) << 16)
//    | (((int)roundf(b * 255)) << 8)
//    | (((int)roundf(a * 255)));
    
    return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)))
    | (((int)roundf(a * 1)));
}

- (NSString *)hexStringFromColor
{
    if([self alpha] != 1.0)
       
       return [NSString stringWithFormat:@"%0.6lX", self.rgbHex];
    else
       return [NSString stringWithFormat:@"%0.8lX",self.rgbaHex];

}


- (NSString *)hexString
{
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex) {
        NSString* alphaString = [NSString stringWithFormat:@"%02lx",
                                 (unsigned long)(self.alpha * 255.0 + 0.5)];
        hex = [NSString stringWithFormat:@"0x%@%@",alphaString,hex];
    }
    return hex;
}



+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if(inColorString.length == 0){
        return nil;
    }
        
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

- (UIColor *)appendMaskRGBColor:(UIColor *)maskColor
{
    CGFloat r,g,b,a;
    CGFloat mr, mg, mb, ma;
    BOOL isRGBColor = [self getRed:&r green:&g blue:&b alpha:&a];
    BOOL isMaskRGB = [maskColor getRed:&mr green:&mg blue:&mb alpha:&ma];
    if (isRGBColor && isMaskRGB)
    {
        r = (r + mr)/2;
        g = (g + mg)/2;
        b = (b + mb)/2;
        a = (a + ma)/2;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return self;
}

- (UIColor *)colorByMutilFactor:(CGFloat)factor
{
    CGFloat r,g,b,a;
    BOOL isRGBColor = [self getRed:&r green:&g blue:&b alpha:&a];
    if (isRGBColor)
    {
        r *= factor;
        g *= factor;
        b *= factor;
        a *= factor;
        r = MAX(0, MIN(1, r));
        g = MAX(0, MIN(1, g));
        b = MAX(0, MIN(1, b));
        a = MAX(0, MIN(1, a));
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return self;
}

//判断颜色是否相同
- (BOOL)isEqualToColor:(UIColor*)secondColor
{
    if(CGColorEqualToColor(self.CGColor, secondColor.CGColor))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断颜色是否相同
+ (BOOL)oneColor:(UIColor *)oneColor isEqualToColor:(UIColor*)secondColor
{
    if((oneColor == secondColor) || CGColorEqualToColor(oneColor.CGColor, secondColor.CGColor))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
