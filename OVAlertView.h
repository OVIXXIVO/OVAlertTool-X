//
//  OVAlertView.h
//  OVAlertView
//
//  Created by 王子翰 on 2017/2/1.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertActionWithTitle)(NSString  * _Nonnull);

typedef enum
{
    MapSpanCity = 0,
    MapSpanStreet = 1
}
MapSpan;

@interface OVAlertView : UIView

+ (nonnull __kindof UIView *) showAlertLocation:(BOOL)showLocation mapSpan:(MapSpan)mapSpan imagePath:(nullable NSString *)imagePath andImageName:(nullable NSString *)imageName title:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nullable NSArray <NSString *>*)actionNames canCloseWithTap:(BOOL)closeWithTap haveRadius:(BOOL)haveRadius;

@property (copy, nonatomic, nonnull) AlertActionWithTitle alertActionWithTitle;

@end
