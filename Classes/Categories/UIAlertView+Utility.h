//
//  UIAlertView+Utility.h
//  2bulu-QuanZi
//
//  Created by 罗亮富 on 14-5-5.
//  Copyright (c) 2014年 Lolaage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertCallBackBlock)(NSUInteger buttonIndex);

@interface UIAlertView (Utility)

@property (nonatomic, strong) AlertCallBackBlock selectionBlock;

+(UIAlertView *)showMsg:(NSString *)msg;
//+(UIAlertView *)showMsg:(NSString *)msg detailText:(NSString *)detailText;

+(UIAlertView *)showYesOrNoWithMsg:(NSString *)msg actionBlock:(AlertCallBackBlock)block;
+(UIAlertView *)showYesOrNoWithMsg:(NSString *)msg detailText:(NSString *)detailText actionBlock:(AlertCallBackBlock)block;

+(UIAlertView *)showAlert:(NSString *)title msg:(NSString *)msg;

//2018-6-12 lotus add
+(void)showAlert:(NSString *)title msg:(NSString *)msg
    cancelAction:(NSString *)cancel
          action:(NSArray <NSString*>*)actions
     actionBlock:(AlertCallBackBlock)block;
//end.

/**
 *  alertView 显示信息
 *
 *  @param msg  要显示的信息
 *  @param time 持续时间
 *
 *  @return alertView
 */
+(UIAlertView *)showMsg:(NSString *)msg duration:(NSUInteger)time;

/**
 *  alertView 显示信息
 *
 *  @param title alert 标题
 *  @param msg  要显示的信息
 *  @param time 持续时间
 *
 *  @return alertView
 */
+(UIAlertView *)showAlert:(NSString *)title msg:(NSString *)msg duration:(NSUInteger)time;

@end



