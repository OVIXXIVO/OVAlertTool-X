//
//  OVProgressView.h
//  OvProgressView
//
//  Created by 王子翰 on 2017/1/12.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OVProgressView : UIView

- (instancetype) initWithFrame:(CGRect)frame andLineWidth:(CGFloat)lineWidth andLineColor:(NSArray *)lineColor;

- (void) stopAndHide;

@end
