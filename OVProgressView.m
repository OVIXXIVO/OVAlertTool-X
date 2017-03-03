//
//  OVProgressView.h
//  OvProgressView
//
//  Created by 王子翰 on 2017/1/12.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import "OVProgressView.h"

@interface OVProgressView ()

@property (nonatomic, assign) CGFloat lineWidth; /**<边框宽度*/
@property (nonatomic, strong) NSArray *lineColor; /**<边框颜色*/

@property (nonatomic, weak) CAShapeLayer *progressLayer; /**<进度条*/
@end

@implementation OVProgressView

- (instancetype) initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                  andLineWidth:3.0
                  andLineColor:@[
                                 [UIColor redColor],
                                 [UIColor greenColor],
                                 [UIColor blueColor]]];
}

- (instancetype) initWithFrame:(CGRect)frame andLineWidth:(CGFloat)lineWidth andLineColor:(NSArray *)lineColor
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = lineWidth;
        self.lineColor = lineColor;
        [self performSelector:@selector(createBaseView)];
    }
    return self;
}

- (void) createBaseView
{    
    //外层旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0.0;
    rotationAnimation.toValue = @(2*M_PI);
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.duration = 3.0;
    rotationAnimation.beginTime = 0.0;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    //内层进度条动画
    CABasicAnimation *strokeAnim1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnim1.fromValue = @0.0;
    strokeAnim1.toValue = @1.0;
    strokeAnim1.duration = 1.0;
    strokeAnim1.beginTime = 0.0;
    strokeAnim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
   
    //内层进度条动画
    CABasicAnimation *strokeAnim2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeAnim2.fromValue = @0.0;
    strokeAnim2.toValue = @1.0;
    strokeAnim2.duration = 1.0;
    strokeAnim2.beginTime = 1.0;
    strokeAnim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = 2.0;
    animGroup.repeatCount = HUGE_VALF;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.animations = @[strokeAnim1, strokeAnim2];
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.lineWidth, self.lineWidth, CGRectGetWidth(self.frame)-self.lineWidth*2, CGRectGetHeight(self.frame)-self.lineWidth*2)];
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.lineWidth = self.lineWidth;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.strokeColor = ((UIColor *)self.lineColor[0]).CGColor;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeStart = 0.0;
    progressLayer.strokeEnd = 1.0;
    progressLayer.path = path.CGPath;
    [progressLayer addAnimation:animGroup forKey:@"strokeAnim"];
    [self.layer addSublayer:progressLayer];
    self.progressLayer = progressLayer;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(randomColor)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void) randomColor
{
    UIColor *color = (UIColor *)[self.lineColor objectAtIndex:arc4random()%self.lineColor.count];
    self.progressLayer.strokeColor = color.CGColor;
}

- (void) stopAndHide
{
    self.progressLayer.hidden = YES;
    self.layer.hidden = YES;
    self.progressLayer = nil;
}

@end
