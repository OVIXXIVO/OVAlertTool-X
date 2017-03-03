//
//  OVActionSheet.h
//  OVAlertView
//
//  Created by 王子翰 on 2017/2/1.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionSheetWithTitle)(NSString  * _Nonnull);

@interface OVActionSheet : UIView

@property (copy, nonatomic, nonnull) ActionSheetWithTitle actionSheetWithTitle;

+ (nonnull __kindof UIView *) showOVActionSheetWithTitle:(nonnull NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames canCloseWithTap:(BOOL)closeWithTap haveRadius:(BOOL)haveRadius;

@end
