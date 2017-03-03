//
//  OVActionSheet.m
//  OVAlertView
//
//  Created by 王子翰 on 2017/2/1.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import "OVActionSheet.h"
#import "SpecialLetter.h"

/**
 *  基本颜色
 */
#define DEF_BASE_COLOR [UIColor colorWithRed:235.00f / 255.00f green:57.00f / 255.00f blue:71.00f / 255.00f alpha:1.00f]

static NSString *_title;

static NSString *_message;

static NSArray *_actionNames;

static BOOL _closeWithTap;

static BOOL _haveRadius;

static CGFloat const kTimeInterval = 0.60f;

static CGFloat const kBgViewWidth = 260.00f;

static CGFloat const kRadius = 15.00f;

static CGFloat const kRowHeight = 50.00f;

static CGFloat const kMargin = 20.00f;

static CGFloat const kLabelHeight = 30.00f;

static NSString * const kReuseId = @"OVAlertCell";

static CGFloat const kLineHeight = 0.30f;

#define WeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;//弱引用

#define DEF_WIDTH self.bounds.size.width

#define DEF_HEIGHT self.bounds.size.height

#define DEF_DEVICE self.bounds.size.width / 320.00f

#define DEF_LINE_COLOR [UIColor colorWithWhite:0.20f alpha:0.20f]


@interface OVActionSheet () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UILabel *titleLabel;

@property (weak, nonatomic) UIView *bgView;

@property (assign, nonatomic) CGFloat height;

@end


@implementation OVActionSheet

+ (nonnull __kindof UIView *) showOVActionSheetWithTitle:(nonnull NSString *)title message:(nullable NSString *)message andActionName:(nonnull NSArray <NSString *>*)actionNames canCloseWithTap:(BOOL)closeWithTap haveRadius:(BOOL)haveRadius
{
    _title = title;
    _message = message;
    _actionNames = actionNames;
    _closeWithTap = closeWithTap;
    _haveRadius = haveRadius;
    
    OVActionSheet *actionSheet = [[OVActionSheet alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return actionSheet;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = self.bounds;
        effectview.alpha = 0;
        [self addSubview:effectview];
        
        WeakSelf(weakSelf)
        
        [UIView animateWithDuration:kTimeInterval / 2 animations:
         ^{
             effectview.alpha = 0.80f;
         }
                         completion:^(BOOL finished)
         {
             //总高度
             CGFloat height = 0;
             
             CGFloat bgViewWidth = kBgViewWidth * DEF_DEVICE;
             CGFloat bgViewHeight = DEF_HEIGHT / 4;
             
             UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((DEF_WIDTH - bgViewWidth) / 2, DEF_HEIGHT, bgViewWidth, bgViewHeight)];
             bgView.backgroundColor = [UIColor whiteColor];
             if (_haveRadius == 1)
             {
                 bgView.layer.masksToBounds = YES;
                 bgView.layer.cornerRadius = kRadius;
             }
             [weakSelf addSubview:bgView];
             weakSelf.bgView = bgView;
             
             if (_title.length != 0 && _title)
             {
                 //title
                 UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin / 2, bgViewWidth - kMargin * 2, kLabelHeight)];
                 titleLabel.textAlignment = NSTextAlignmentCenter;
                 titleLabel.numberOfLines = 0;
                 titleLabel.textColor = [UIColor colorWithWhite:0.20f alpha:0.80f];
                 titleLabel.font = [UIFont systemFontOfSize:16.50f weight:- 0.30f];
                 titleLabel.text = _title;
                 CGSize titleLabelSize = [_title boundingRectWithSize:CGSizeMake(bgViewWidth - kMargin * 2, bgViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.00f]} context:nil].size;
                 titleLabel.frame = CGRectMake(kMargin, kMargin, bgViewWidth - kMargin * 2, titleLabelSize.height);
                 [bgView addSubview:titleLabel];
                 weakSelf.titleLabel = titleLabel;
                 height = CGRectGetMaxY(titleLabel.frame) + kMargin;
             }
             
             if (_message.length != 0 && _message)
             {
                 //message
                 UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin / 2 + CGRectGetMaxY(weakSelf.titleLabel.frame), bgViewWidth - kMargin * 2, kLabelHeight)];
                 messageLabel.textAlignment = NSTextAlignmentCenter;
                 messageLabel.numberOfLines = 0;
                 messageLabel.textColor = [UIColor colorWithWhite:0.30f alpha:0.60f];
                 messageLabel.font = [UIFont systemFontOfSize:14.00f weight:- 0.30f];
                 messageLabel.text = _message;
                 CGSize messageLabelSize = [_message boundingRectWithSize:CGSizeMake(bgViewWidth - kMargin * 2, bgViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.50f]} context:nil].size;
                 messageLabel.frame = CGRectMake(kMargin, kMargin / 2 + CGRectGetMaxY(weakSelf.titleLabel.frame), bgViewWidth - kMargin * 2, messageLabelSize.height);
                 [bgView addSubview:messageLabel];
                 height = CGRectGetMaxY(messageLabel.frame) + kMargin;
             }
             
             //事件
             UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, bgViewWidth, kRowHeight * _actionNames.count) style:UITableViewStylePlain];
             tableView.bounces = NO;
             tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//分割线样式
             [bgView addSubview:tableView];
             tableView.delegate = weakSelf;
             tableView.dataSource = weakSelf;
             
             height = CGRectGetMaxY(tableView.frame);
             self.height = height;
             
             bgView.frame = CGRectMake((DEF_WIDTH - bgViewWidth) / 2, DEF_HEIGHT, bgViewWidth, height);
             
             [UIView animateWithDuration:kTimeInterval / 2 animations:
              ^{
                  bgView.frame = CGRectMake((DEF_WIDTH - bgViewWidth) / 2, DEF_HEIGHT - height - kMargin, bgViewWidth, height);
              }
                              completion:^(BOOL finished)
              {
                  
              }];
             
         }];
    }
    return self;
}


#pragma mark - 触摸事件

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_closeWithTap == 1)
    {
        [self hideAndRemove];
    }
}


#pragma mark - 隐藏

- (void) hideAndRemove
{
    [UIView animateWithDuration:kTimeInterval / 2 animations:
     ^{
         self.bgView.frame = CGRectMake((DEF_WIDTH - kBgViewWidth * DEF_DEVICE) / 2, DEF_HEIGHT, kBgViewWidth * DEF_DEVICE, self.height);
     }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}


#pragma mark - tableView delegate

/**
 *  点选的row
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:NULL animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self hideAndRemove];
    
    if (_actionSheetWithTitle)
    {
        _actionSheetWithTitle(_actionNames[indexPath.row]);
    }
}

/**
 *  row高度
 */
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}


#pragma mark - tableView dataSouce

/**
 *  行数
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _actionNames.count;
}

/**
 *  UITableViewCell
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseId];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseId];
        cell.textLabel.font = [UIFont systemFontOfSize:15.00f weight:- 0.40f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;        
    }
    
    if (indexPath.row == 0)
    {
        //上
        UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBgViewWidth * DEF_DEVICE, kLineHeight)];
        lineView0.backgroundColor = DEF_LINE_COLOR;
        [cell addSubview:lineView0];
    }
    
    if (indexPath.row != _actionNames.count - 1)
    {
        //底
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kRowHeight - kLineHeight, kBgViewWidth * DEF_DEVICE, kLineHeight)];
        lineView1.backgroundColor = DEF_LINE_COLOR;
        [cell addSubview:lineView1];
    }
    
    cell.textLabel.text = _actionNames[indexPath.row];
    
    BOOL containSpecial = [SpecialLetter judgeSpecialLetterWithString:_actionNames[indexPath.row]];
    
    if (containSpecial == 1)
    {
        cell.textLabel.textColor = DEF_BASE_COLOR;
    }
    else
    {
        cell.textLabel.textColor = [UIColor colorWithWhite:0.20f alpha:0.80f];
    }
    
    return cell;
}


#pragma mark - dealloc

- (void) dealloc
{
    
}

@end
