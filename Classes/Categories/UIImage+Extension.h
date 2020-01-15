//
//  UIImage+Extension.h
//  MetalApp
//
//  Created by vince on 13-4-9.
//  Copyright (c) 2013年 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)
+(UIImage*) imageWithNameType:(NSString*)name;
+(UIImage *)imageFromView:(UIView *)view;

- (UIImage *)imageAtRect:(CGRect)rect;

//截取当前屏幕
+ (UIImage *)imageWithScreenshot;
///和 imageByScalingProportionallyToMinimumSize 一样, 但如果图片是正方形的话则没有效果
- (UIImage *)imageByScalingProportionallyToDifferenceSize:(CGSize)targetSize;

//获取相册中最近的图片的
+ (void)getLatestAssetFromLibrary:(void (^)(UIImage * _Nullable image,NSDate *imageCreatedDate))getImageBloc;

///按比例缩小填充,多余部分裁剪
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
///按比例缩小, 不裁剪, 空白部分以透明填充
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
//短边限制像素点进行
-(UIImage *)resizeByShorterSideLimit:(CGFloat)limit;

//返回image的Data
- (nullable  NSData *)imageData;
//根据本地地址获取本地图片 一定要是本地地址
+ (nullable UIImage*)imageWithLocalFilePath:(NSString *)localFilePath;//

///图片裁剪
- (UIImage*)crop:(CGRect)rect;

/**
 *  把A图片画到B图片上
 *
 *  @param image     A图片
 *  @param backImage B图片
 *  @param frame     A在B图片上的位置
 *
 *  @return 返回合成的图片
 */
+ (UIImage*)drawImage:(UIImage *)image onOtherImage:(UIImage *)backImage withFrame:(CGRect) frame;

//给图片添加户外助手的水印
- (UIImage *)imageByAddWaterMark;

///不按比例缩小至指定尺寸
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToWidth:(float)width;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
+ (id)createRoundedRectImage:(UIImage*)image radius:(NSInteger)r;
+ (id)createRoundedRectImage:(UIImage*)image;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
- (UIImage *)fixOrientation:(UIImage *)aImage;
@end

@interface UIImage(ResizeCategory)
-(UIImage*)resizedImageToSize:(CGSize)dstSize;
-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
@end



@interface UIImage (Edit)
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageRotatedByRadians:(CGFloat)rotation;


//压缩图片 用默认压缩比例
- (NSData *)compressImageData;


//压缩图片 //压缩图片 压缩图片  0<= compress <= 1   当 compress ==0 时 用默认压缩
- (NSData *)imageDataCompress:(CGFloat)compress;

//给图片添加文字水印
+ (UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name withFrame:(CGRect)frame  withFont:(UIFont *)font textColor:(UIColor *_Nullable)textcoclor;

@end

@interface UIImage (Vedio)


//获取视频封面图片
/*    暂定个截取视频封面的方案，
 1、先判断第一帧是否是彩色图片，不是走2，是取第一帧的
 2、判断第二秒是否为彩色图片，不是走3，是取第二秒的
 3、取第四秒的图片
现在的逻辑是，依次判断第一帧，第二秒，第四秒，第六秒的图片是否灰度差大于50，大于就返回当前秒的图片，否则就用下一个图。每次取图都要判断是否是在视频时长内。
 */
+(UIImage *)imageFromLocalVideoPath:(NSString *)videoPath;
//获取视频封面图片 获取网络视频图片 可能失败 而且耗时很长
+ (UIImage*) getVideoPreViewImageWithVideoURL:(NSURL *)videoURL;

//获取图片某一点的颜色
- (UIColor *)colorAtPixel:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
