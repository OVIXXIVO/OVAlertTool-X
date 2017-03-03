//
//  OVAlertTool.h
//  OVAlertView
//
//  Created by 王子翰 on 2017/2/2.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    OVAlertMapSpanCity = 0,
    OVAlertMapSpanStreet = 1
}
OVAlertMapSpan;

@interface OVAlertTool : NSObject

/**
 *  alert
 */
+ (void) showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames toView:(nonnull UIView *)superView handle:(nullable void (^)(NSString * _Nonnull actionName))handle;

/**
 *  alert 带图片 有事件
 */
+ (void) showImageAlertWithImagePath:(nullable NSString *)imagePath andImageName:(nullable NSString *)imageName title:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames toView:(nonnull UIView *)superView handle:(nullable void (^)(NSString * _Nonnull actionName))handle;

/**
 *  alert 带图片 无事件
 */
+ (void) showImageAlertWithImagePath:(nullable NSString *)imagePath andImageName:(nullable NSString *)imageName title:(nullable NSString *)title message:(nullable NSString *)message toView:(nonnull UIView *)superView;

/**
 *  alert 有地图 有事件
 */
+ (void) showMapAlertWithMapSpan:(OVAlertMapSpan)mapSpan title:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames toView:(nonnull UIView *)superView handle:(nullable void (^)(NSString * _Nonnull actionName))handle;

/**
 *  actionSheet
 */
+ (void) showActionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames canCloseWithTap:(BOOL)closeWithTap toView:(nonnull UIView *)superView handle:(nullable void (^)(NSString * _Nonnull actionName))handle;

/**
 *  message 2.00s后销毁
 */
+ (void) showMessageWithMessage:(nullable NSString *)message toView:(nonnull UIView *)superView;

/**
 *  进度圈
 */
+ (void) showProgressViewWithMessage:(nullable NSString *)message toView:(nonnull UIView *)superView;

/**
 *  移除进度圈
 */
+ (void) hideProgressView;

@end
