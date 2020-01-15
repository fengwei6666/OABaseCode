//
//  UIAlertView+Utility.m
//  2bulu-QuanZi
//
//  Created by 罗亮富 on 14-5-5.
//  Copyright (c) 2014年 Lolaage. All rights reserved.
//


#import "UIAlertView+Utility.h"
#import <objc/runtime.h>

static char blockKey;

@implementation UIAlertView (Utility)

-(void)setSelectionBlock:(AlertCallBackBlock)selectionBlock
{
    self.delegate = self;
    objc_setAssociatedObject(self, &blockKey, selectionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(AlertCallBackBlock)selectionBlock
{
    return objc_getAssociatedObject(self, &blockKey);
}

+(UIAlertView *)showMsg:(NSString *)msg
{
    return [self showAlert:nil msg:msg];
}


+(UIAlertView *)showMsg:(NSString *)msg detailText:(NSString *)detailText
{
    NSString *noButonTitle = NSLocalizedString(@"确定",nil);;
    NSString *yesButtonTitle = nil;
    
    yesButtonTitle = NSLocalizedString(@"是",nil);
    noButonTitle = NSLocalizedString(@"否",nil);
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:msg message:detailText delegate:self
                                        cancelButtonTitle:noButonTitle
                                        otherButtonTitles:yesButtonTitle,nil];
    [alert show];
    
    return alert;
}

+(UIAlertView *)showYesOrNoWithMsg:(NSString *)msg actionBlock:(AlertCallBackBlock)block
{
    UIAlertView *alv = [self showMsg:NSLocalizedString(@"提示", nil) detailText:msg];
    alv.selectionBlock = block;
    return alv;
}

+(UIAlertView *)showYesOrNoWithMsg:(NSString *)msg detailText:(NSString *)detailText actionBlock:(AlertCallBackBlock)block
{
    UIAlertView *alv = [self showMsg:msg detailText:detailText];
    alv.selectionBlock = block;
    return alv;
}


+(UIAlertView *)showAlert:(NSString *)title msg:(NSString *)msg
{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles: nil];
    if([NSThread currentThread].isMainThread)
        [alert show];
    else
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    return alert;
    
}

+(void)showAlert:(NSString *)title msg:(NSString *)msg
    cancelAction:(NSString *)cancel
          action:(NSArray <NSString*>*)actions
     actionBlock:(AlertCallBackBlock)block{

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancel otherButtonTitles: nil];
    [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alert addButtonWithTitle:obj];
    }];
    alert.selectionBlock = block;
    [alert show];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(self.selectionBlock)
//        self.selectionBlock(buttonIndex);
//}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.selectionBlock)
        self.selectionBlock(buttonIndex);
}

/**
 *  alertView 显示信息
 *
 *  @param msg  要显示的信息
 *  @param time 持续时间
 *
 *  @return alertView
 */

+(UIAlertView *)showMsg:(NSString *)msg duration:(NSUInteger)time
{
    return [self showAlert:nil msg:msg duration:time];
}

/**
 *  alertView 显示信息
 *
 *  @param title alert 标题
 *  @param msg  要显示的信息
 *  @param time 持续时间
 *
 *  @return alertView
 */

+(UIAlertView *)showAlert:(NSString *)title msg:(NSString *)msg duration:(NSUInteger)time
{
    UIAlertView *alert = [self showAlert:title msg:msg];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    return alert;
}

@end

