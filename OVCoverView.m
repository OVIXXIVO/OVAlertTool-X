//
//  OVCoverView.m
//  特产地
//
//  Created by 王子翰 on 2017/1/12.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import "OVCoverView.h"
#import "OVProgressView.h"

static CGFloat const kProgressViewLength = 40.00f;

static CGFloat const kMargin = 20.00f;

static NSString *_message;

/**
 *  基本颜色
 */
#define DEF_BASE_COLOR [UIColor colorWithRed:235.00f / 255.00f green:57.00f / 255.00f blue:71.00f / 255.00f alpha:1.00f]

@interface OVCoverView ()

@property (weak, nonatomic) OVProgressView *progressView;

@end

@implementation OVCoverView


+ (nonnull __kindof UIView *) createOVCoverViewWithMessage:(nullable NSString *)message
{
    _message = message;
    
    OVCoverView *coverView = [[OVCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return coverView;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = frame;
        effectview.alpha = 0.80f;
        [self addSubview:effectview];
        
//        UIView *bgView = [[UIView alloc] init];
//        bgView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
//        bgView.bounds = CGRectMake(0, 0, frame.size.width / 2, frame.size.height / 2);
//        bgView.backgroundColor = [UIColor clearColor];
//        [self addSubview:bgView];
//        
        //进度圈
        NSArray *colorArray = @[
                                DEF_BASE_COLOR
                                ];
        OVProgressView *progressView = [[OVProgressView alloc] initWithFrame:CGRectMake(0, 0, kProgressViewLength, kProgressViewLength) andLineWidth:3.0 andLineColor:colorArray];
        
        if (!_message || _message.length == 0)
        {
            progressView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        }
        else
        {
            CGSize size = [_message boundingRectWithSize:CGSizeMake(frame.size.width / 2, frame.size.height / 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.50f]} context:nil].size;
            
            CGFloat labelHeight = size.height;            
            CGFloat height = kProgressViewLength + labelHeight + kMargin;
            
            //progressView 的frame
            CGFloat progressX = (frame.size.width - kProgressViewLength) / 2;
            CGFloat progressY = (frame.size.height - height) / 2;
            progressView.frame = CGRectMake(progressX, progressY, kProgressViewLength, kProgressViewLength);
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 4, CGRectGetMaxY(progressView.frame) + kMargin, frame.size.width / 2, labelHeight)];
            label.numberOfLines = 0;
            label.textColor = [UIColor colorWithWhite:0.20f alpha:0.80f];
            label.font = [UIFont systemFontOfSize:16.00f weight:- 0.30f];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = _message;
            [self addSubview:label];
        }
        
        [self addSubview:progressView];
        self.progressView = progressView;
    }
    return self;
}


#pragma mark - 隐藏 销毁

- (void) hideCoverView
{
    [self.progressView stopAndHide];
    [self removeFromSuperview];
}


#pragma mark - 重写 覆盖

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
