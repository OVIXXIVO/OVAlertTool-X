//
//  OVCoverView.h
//  特产地
//
//  Created by 王子翰 on 2017/1/12.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OVCoverView : UIView

+ (nonnull __kindof UIView *) createOVCoverViewWithMessage:(nullable NSString *)message;

- (void) hideCoverView;

@end
