//
//  OVAlertTool.m
//  OVAlertView
//
//  Created by 王子翰 on 2017/2/2.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import "OVAlertTool.h"
#import "OVAlertView.h"
#import "OVActionSheet.h"
#import "OVCoverView.h"

static OVCoverView *_coverView;

@interface OVAlertTool ()


@end

@implementation OVAlertTool


#pragma mark - alert 无图

+ (void) showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames toView:(nonnull UIView *)superView handle:(nullable void (^)(NSString * _Nonnull actionName))handle
{
    OVAlertView *view = [OVAlertView showAlertLocation:0 mapSpan:0 imagePath:nil andImageName:nil title:title message:message andActionName:actionNames canCloseWithTap:NO haveRadius:YES];
    view.alertActionWithTitle = ^(NSString * _Nonnull alertTitle)
    {
        handle(alertTitle);
    };
    [superView addSubview:view];
}


#pragma mark - alert 有图

+ (void) showImageAlertWithImagePath:(nullable NSString *)imagePath andImageName:(nullable NSString *)imageName title:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames toView:(nonnull UIView *)superView handle:(nullable void (^)(NSString * _Nonnull actionName))handle
{
    OVAlertView *view = [OVAlertView showAlertLocation:0  mapSpan:0 imagePath:imagePath andImageName:imageName title:title message:message andActionName:actionNames canCloseWithTap:NO haveRadius:YES];
    view.alertActionWithTitle = ^(NSString * _Nonnull alertTitle)
    {
        handle(alertTitle);
    };
    [superView addSubview:view];
}


#pragma mark - alert 有图 无事件

+ (void) showImageAlertWithImagePath:(nullable NSString *)imagePath andImageName:(nullable NSString *)imageName title:(nullable NSString *)title message:(nullable NSString *)message toView:(nonnull UIView *)superView
{
    OVAlertView *view = [OVAlertView showAlertLocation:0  mapSpan:0 imagePath:imagePath andImageName:imageName title:title message:message andActionName:nil canCloseWithTap:YES haveRadius:YES];
    [superView addSubview:view];
}


#pragma mark - alert 有地图

+ (void) showMapAlertWithMapSpan:(OVAlertMapSpan)mapSpan title:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames toView:(nonnull UIView *)superView handle:(nullable void (^)(NSString * _Nonnull actionName))handle
{
    MapSpan span = 0;
    if (mapSpan == OVAlertMapSpanCity)
    {
        span = MapSpanCity;
    }
    else if (mapSpan == OVAlertMapSpanStreet)
    {
        span = MapSpanStreet;
    }
    OVAlertView *view = [OVAlertView showAlertLocation:1  mapSpan:span  imagePath:nil andImageName:nil title:title message:message andActionName:actionNames canCloseWithTap:NO haveRadius:YES];
    view.alertActionWithTitle = ^(NSString * _Nonnull alertTitle)
    {
        handle(alertTitle);
    };
    [superView addSubview:view];
}


#pragma mark - actionsheet

+ (void) showActionSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames canCloseWithTap:(BOOL)closeWithTap toView:(nonnull UIView *)superView handle:(nullable void (^)(NSString * _Nonnull actionName))handle
{
    OVActionSheet *view = [OVActionSheet showOVActionSheetWithTitle:title message:message andActionName:actionNames canCloseWithTap:YES haveRadius:YES];
    view.actionSheetWithTitle = ^(NSString * _Nonnull alertTitle)
    {
        handle(alertTitle);
    };
    [superView addSubview:view];
}


#pragma mark - message

+ (void) showMessageWithMessage:(nullable NSString *)message toView:(nonnull UIView *)superView
{
    OVAlertView *view = [OVAlertView showAlertLocation:0  mapSpan:0  imagePath:nil andImageName:nil title:message message:nil andActionName:nil canCloseWithTap:YES haveRadius:YES];
    [superView addSubview:view];
}


#pragma mark - 进度圈

+ (void) showProgressViewWithMessage:(nullable NSString *)message toView:(nonnull UIView *)superView
{
    OVCoverView *coverView = [OVCoverView createOVCoverViewWithMessage:message];    
    [superView addSubview:coverView];
    _coverView = coverView;
}


#pragma mark - 隐藏进度圈

+ (void) hideProgressView
{
    [_coverView hideCoverView];
}



@end
