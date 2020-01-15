//
//  UIFont+style.h
//  lksdfjlk
//
//  Created by Weifeng on 16/7/11.
//  Copyright © 2016年 Weifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef APP_FONT

#define APP_FONT

#define UIFontWithName(fontName,fontSize)         [UIFont fontWithName:fontName size:(fontSize)]?:[UIFont systemFontOfSize:fontSize]

//APP字体 light
#define APP_LIGHT_FONT(fontSize)           UIFontWithName(@"PingFangSC-Light", fontSize)

//APP字体 Regular
#define APP_REGULAR_FONT(fontSize)         UIFontWithName(@"PingFangSC-Regular", fontSize)

//APP字体 粗体 Semibold
#define APP_BOLD_FONT(fontSize)            UIFontWithName(@"PingFangSC-Semibold", fontSize)

//APP默认字体  （如未指明一般情况用这种）
#define APP_DEFAULT_FONT(fontSize)         APP_REGULAR_FONT(fontSize)

//APP字体 Medium
#define APP_MEDIUM_FONT(fontSize)          UIFontWithName(@"PingFangSC-Medium", fontSize)

//一种特效数字字母字体
#define DIGITAL_FONT(fontSize)             UIFontWithName(@"LetsgoDigital-Regular", fontSize)

//6.2字体配置
//正文、按钮字体
#define kMainTextFont   APP_REGULAR_FONT(16)
#define kSubTextFont    APP_REGULAR_FONT(12)

#endif

@interface UIFont (style)

@property (nonatomic, readonly) BOOL isBold;        ///< Whether the font is bold.
@property (nonatomic, readonly) BOOL isItalic;      ///< Whether the font is italic.
@property (nonatomic, readonly) CGFloat fontWeight; ///< Font weight from -1.0 to 1.0. Regular weight is 0.0.

/**
 Create a bold font from receiver.
 @return A bold font, or nil if failed.
 */
- (UIFont *)fontWithBold;

/**
 Create a italic font from receiver.
 @return A italic font, or nil if failed.
 */
- (UIFont *)fontWithItalic;

/**
 Create a bold and italic font from receiver.
 @return A bold and italic font, or nil if failed.
 */
- (UIFont *)fontWithBoldItalic;

/**
 Create a normal (no bold/italic/...) font from receiver.
 @return A normal font, or nil if failed.
 */
- (UIFont *)fontWithNormal;

/**
 *  debug状态下打印所有的系统字体
 */
+ (void)debugDescriptAllSystemFonts;


///**
// *  户外助手默认字体
// */
//+ (UIFont *)lolaFontOfSize:(CGFloat)fontSize;
//
//
////粗体
//+ (UIFont *)boldLolaFontOfSize:(CGFloat)fontSize;

@end
