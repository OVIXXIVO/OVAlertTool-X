//
//  OVAlertImageView.m
//  OValertImageView
//
//  Created by 王子翰 on 2017/2/3.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import "OVAlertView.h"
#import "SpecialLetter.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>

static NSString *_imagePath;

static NSString *_imageName;

/**
 *  基本颜色
 */
#define DEF_BASE_COLOR [UIColor colorWithRed:235.00f / 255.00f green:57.00f / 255.00f blue:71.00f / 255.00f alpha:1.00f]

static BOOL _showLocation;

static NSString *_title;

static NSString *_message;

static NSArray *_actionNames;

static BOOL _closeWithTap;

static BOOL _haveRadius;

static MapSpan _mapSpan;

static CGFloat _span;

static CGFloat const kTimeInterval = 0.60f;

static CGFloat const kBgViewWidth = 260.00f;

static CGFloat const kRadius = 15.00f;

static CGFloat const kRowHeight = 50.00f;

static CGFloat const kMargin = 20.00f;

static CGFloat const kLabelHeight = 30.00f;

static NSString * const kReuseId = @"OVAlertImageCell";

static CGFloat const kLineHeight = 0.25f;

static CGFloat const kLineHeightX = 0.50f;

#define DEF_WIDTH self.bounds.size.width

#define DEF_HEIGHT self.bounds.size.height

#define DEF_DEVICE self.bounds.size.width / 320.00f

#define DEF_LINE_COLOR [UIColor colorWithWhite:0.20f alpha:0.20f]

#define WeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;//弱引用

@interface OVAlertView ()<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) UILabel *titleLabel;

@property (weak, nonatomic) MKMapView *mapView;

// 这个属性主要用来请求权限
@property (strong, nonatomic) CLLocationManager *manager;

@property (weak, nonatomic) NSTimer *timer;

@property (assign, nonatomic) CGFloat titleLabelWidth;

@property (assign, nonatomic) CGFloat titleLabelHeight;

@property (weak, nonatomic) UIView *bgView;

@property (assign, nonatomic) CGRect mapViewFrame;

@property (weak, nonatomic) UIButton *myLocationButton;

@property (weak, nonatomic) UIButton *closeButton;

@end

@implementation OVAlertView

#pragma mark - 懒加载

- (CLLocationManager *) manager
{
    if (!_manager)
    {
        _manager = [[CLLocationManager alloc] init];
    }
    return _manager;
}


#pragma mark - 创建

+ (nonnull __kindof UIView *) showAlertLocation:(BOOL)showLocation mapSpan:(MapSpan)mapSpan imagePath:(nullable NSString *)imagePath andImageName:(nullable NSString *)imageName title:(nullable NSString *)title message:(nullable NSString *)message andActionName:(nullable NSArray <NSString *>*)actionNames canCloseWithTap:(BOOL)closeWithTap haveRadius:(BOOL)haveRadius
{
    _showLocation = showLocation;
    _imagePath = imagePath;
    _imageName = imageName;
    _title = title;
    _message = message;
    _actionNames = actionNames;
    _closeWithTap = closeWithTap;
    _haveRadius = haveRadius;
    _mapSpan = mapSpan;
    if (_showLocation == YES)
    {
        if (_mapSpan == MapSpanCity)
        {
            _span = 1.00f;
        }
        else if (_mapSpan == MapSpanStreet)
        {
            _span = 0.005f;
        }
    }
    
    OVAlertView *view = [[OVAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return view;
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
             
             UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((DEF_WIDTH - bgViewWidth) / 2, (DEF_HEIGHT - bgViewHeight) / 2, bgViewWidth, bgViewHeight)];
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
                 
                 self.titleLabelWidth = titleLabelSize.width;
                 self.titleLabelHeight = titleLabelSize.height;
                 
                 [bgView addSubview:titleLabel];
                 weakSelf.titleLabel = titleLabel;
                 height = CGRectGetMaxY(titleLabel.frame) + kMargin;
             }
             
             if (_showLocation == 1)
             {
                 // 请求权限
                 if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)])
                 {
                     [self.manager requestAlwaysAuthorization];
                 }
                 
                 MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(kMargin * 2, height, bgViewWidth - kMargin * 4, bgViewWidth - kMargin * 4)];
                 [bgView addSubview:mapView];
                 self.mapView = mapView;
                 //显示用户位置
                 [self.mapView setShowsUserLocation:YES];
                 //跟踪用户的位置
                 self.mapView.userTrackingMode = MKUserTrackingModeFollow;
                 //设置代理跟踪位置
                 self.mapView.delegate = self;
                 //设置地图类型
                 self.mapView.mapType = MKMapTypeStandard;
                 
                 self.mapViewFrame = mapView.frame;
                 
                 height = CGRectGetMaxY(mapView.frame) + kMargin;
             }
             
             if (_imagePath.length != 0 || _imageName.length != 0)
             {
                 //图片
                 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin * 2, height, bgViewWidth - kMargin * 4, bgViewWidth - kMargin * 4)];
                 [imageView sd_setImageWithURL:[NSURL URLWithString:_imagePath] placeholderImage:[UIImage imageNamed:_imageName]];
                 imageView.contentMode = UIViewContentModeScaleAspectFit;
                 [bgView addSubview:imageView];
                 height = CGRectGetMaxY(imageView.frame) + kMargin;
             }
             
             if (_message.length != 0 && _message)
             {
                 //message
                 UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, kMargin / 2 + height, bgViewWidth - kMargin * 2, kLabelHeight)];
                 messageLabel.textAlignment = NSTextAlignmentCenter;
                 messageLabel.numberOfLines = 0;
                 messageLabel.textColor = [UIColor colorWithWhite:0.30f alpha:0.60f];
                 messageLabel.font = [UIFont systemFontOfSize:14.00f weight:- 0.30f];
                 messageLabel.text = _message;
                 CGSize messageLabelSize = [_message boundingRectWithSize:CGSizeMake(bgViewWidth - kMargin * 2, bgViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.50f]} context:nil].size;
                 messageLabel.frame = CGRectMake(kMargin, kMargin / 2 + height, bgViewWidth - kMargin * 2, messageLabelSize.height);
                 [bgView addSubview:messageLabel];
                 height = CGRectGetMaxY(messageLabel.frame) + kMargin;
             }
             
             //action
             BOOL overLength = 0;
             
             for (int i = 0; i < _actionNames.count; i ++)
             {
                 NSString *actionStr = _actionNames[i];
                 CGFloat strLength = [actionStr boundingRectWithSize:CGSizeMake(bgViewWidth, bgViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.50f]} context:nil].size.width;
                 if (strLength > bgViewWidth / 3)
                 {
                     overLength = 1;
                     break;
                 }
             }
             
             if (_actionNames.count != 0)//有事件
             {
                 if (_actionNames.count <= 2 && overLength == 0 && height != 0 && _showLocation == 0)//2个button
                 {
                     UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
                     leftButton.frame = CGRectMake(0, height, bgViewWidth / 2, kRowHeight);
                     [leftButton setTitle:_actionNames[0] forState:UIControlStateNormal];
                     leftButton.titleLabel.font = [UIFont systemFontOfSize:15.00f weight:- 0.40f];
                     BOOL containSpecial0 = [SpecialLetter judgeSpecialLetterWithString:_actionNames[0]];
                     if (containSpecial0 == 1)
                     {
                         [leftButton setTitleColor:DEF_BASE_COLOR forState:UIControlStateNormal];
                     }
                     else
                     {
                         [leftButton setTitleColor:[UIColor colorWithWhite:0.20f alpha:0.80f] forState:UIControlStateNormal];
                     }
                     [leftButton addTarget:weakSelf action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
                     [bgView addSubview:leftButton];
                     
                     UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                     rightButton.frame = CGRectMake(bgViewWidth / 2, height, bgViewWidth / 2, kRowHeight);
                     [rightButton setTitle:_actionNames[1] forState:UIControlStateNormal];
                     rightButton.titleLabel.font = [UIFont systemFontOfSize:15.00f weight:- 0.40f];
                     BOOL containSpecial1 = [SpecialLetter judgeSpecialLetterWithString:_actionNames[1]];
                     if (containSpecial1 == 1)
                     {
                         [rightButton setTitleColor:DEF_BASE_COLOR forState:UIControlStateNormal];
                     }
                     else
                     {
                         [rightButton setTitleColor:[UIColor colorWithWhite:0.20f alpha:0.80f] forState:UIControlStateNormal];
                     }
                     [rightButton addTarget:weakSelf action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
                     [bgView addSubview:rightButton];
                     
                     UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0, height - kLineHeight, bgViewWidth, kLineHeight * 2)];
                     lineView0.backgroundColor = DEF_LINE_COLOR;
                     [bgView addSubview:lineView0];
                     
                     UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(bgViewWidth / 2 - kLineHeight * 5 / 3, height, kLineHeight, kRowHeight)];
                     lineView1.backgroundColor = DEF_LINE_COLOR;
                     [bgView addSubview:lineView1];
                     [bgView bringSubviewToFront:lineView1];
                     
                     height = CGRectGetMaxY(rightButton.frame);
                 }
                 else
                 {
                     UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, bgViewWidth, kRowHeight * _actionNames.count) style:UITableViewStylePlain];
                     tableView.bounces = NO;
                     tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//分割线样式
                     [bgView addSubview:tableView];
                     tableView.delegate = weakSelf;
                     tableView.dataSource = weakSelf;
                     
                     height = CGRectGetMaxY(tableView.frame);
                 }
             }
             else//没有事件
             {
                 //自动消除
                 NSTimer *timer = [NSTimer timerWithTimeInterval:2.00f target:weakSelf selector:@selector(hideAndRemove) userInfo:nil repeats:NO];
                 NSRunLoop * loop = [NSRunLoop currentRunLoop];
                 [loop addTimer:timer forMode:NSRunLoopCommonModes];
                 weakSelf.timer = timer;
             }
             
             //frame
             if ((_actionNames.count == 0 || !_actionNames) && (_message.length == 0 || !_message) && _imagePath.length == 0 && _imageName.length == 0)
             {
                 //只有title
                 weakSelf.titleLabel.frame = CGRectMake(kMargin / 2, kMargin / 2, self.titleLabelWidth, self.titleLabelHeight);
                 
                 bgView.layer.cornerRadius = 5.00f;
                 bgView.frame = CGRectMake((DEF_WIDTH - self.titleLabelWidth - kMargin) / 2, (DEF_HEIGHT - self.titleLabelHeight) / 2, self.titleLabelWidth + kMargin, self.titleLabelHeight + kMargin);
             }
             else
             {
                 bgView.frame = CGRectMake((DEF_WIDTH - bgViewWidth) / 2, (DEF_HEIGHT - height) / 2, bgViewWidth, height);
             }
         }];
    }
    return self;
}

#pragma mark - 触摸事件

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_showLocation == 1)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        point = [self.bgView.layer convertPoint:point fromLayer:self.layer];
        if ([self.bgView.layer containsPoint:point])
        {
            point = [self.mapView.layer convertPoint:point fromLayer:self.bgView.layer];
            if ([self.mapView.layer containsPoint:point])//地图里面
            {
                if (self.mapView.frame.size.width == self.mapViewFrame.size.width && self.mapView.frame.size.height == self.mapViewFrame.size.height)
                {
                    WeakSelf(weakSelf);
                    
                    [UIView animateWithDuration:kTimeInterval animations:
                     ^{
                         weakSelf.bgView.alpha = 0;
                     }
                                     completion:^(BOOL finished)
                     {
                         [UIView animateWithDuration:kTimeInterval animations:
                          ^{
                              weakSelf.mapView.frame = weakSelf.frame;
                          }
                                          completion:^(BOOL finished)
                          {
                              [weakSelf addSubview:weakSelf.mapView];
                              
                              //图标路径
                              NSString *alertIconsPath = [[NSBundle mainBundle] pathForResource:@"OVAlertIcons" ofType:@"bundle"];
                              NSBundle *alertIconsBundle = [NSBundle bundleWithPath:alertIconsPath];
                              NSString *location_self_normal = [alertIconsBundle pathForResource:@"location_self_normal" ofType:@"png"];
                              NSString *location_self_highlight = [alertIconsBundle pathForResource:@"location_self_highlight" ofType:@"png"];
                              
                              NSString *location_close_normal = [alertIconsBundle pathForResource:@"location_close_normal" ofType:@"png"];
                              NSString *location_close_highlight = [alertIconsBundle pathForResource:@"location_close_highlight" ofType:@"png"];
                              
                              CGFloat margin = 30.00f;
                              CGFloat length = 35.00f;
                              
                              UIButton *myLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
                              myLocationButton.frame = CGRectMake(margin / 2, weakSelf.mapView.bounds.size.height - margin - length, length, length);
                              myLocationButton.layer.masksToBounds = YES;
                              myLocationButton.layer.cornerRadius = length / 2;
                              myLocationButton.backgroundColor = [UIColor colorWithWhite:0.90f alpha:0.80f];
                              [myLocationButton setImage:[UIImage imageWithContentsOfFile:location_self_normal] forState:UIControlStateNormal];
                              [myLocationButton setImage:[UIImage imageWithContentsOfFile:location_self_highlight] forState:UIControlStateHighlighted];
                              [myLocationButton addTarget:weakSelf action:@selector(myLocationButtonClick) forControlEvents:UIControlEventTouchUpInside];
                              [weakSelf.mapView addSubview:myLocationButton];
                              weakSelf.myLocationButton = myLocationButton;
                              
                              UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                              closeButton.frame = CGRectMake(margin / 2, margin, length, length);
                              closeButton.layer.masksToBounds = YES;
                              closeButton.layer.cornerRadius = length / 2;
                              closeButton.backgroundColor = [UIColor colorWithWhite:0.90f alpha:0.80f];
                              [closeButton setImage:[UIImage imageWithContentsOfFile:location_close_normal] forState:UIControlStateNormal];
                              [closeButton setImage:[UIImage imageWithContentsOfFile:location_close_highlight] forState:UIControlStateHighlighted];
                              [closeButton addTarget:weakSelf action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
                              [weakSelf.mapView addSubview:closeButton];
                              weakSelf.closeButton = closeButton;
                          }];
                     }];
                }
            }
            else//地图外面
            {
                
            }
        }
    }
    else
    {
        if (_closeWithTap == 1 || _actionNames.count == 0 || !_actionNames)
        {
            [self hideAndRemove];
        }
    }
}


#pragma mark - 隐藏

- (void) hideAndRemove
{
    [self.timer invalidate];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.timer = nil;
    
    [UIView animateWithDuration:kTimeInterval / 2 animations:
     ^{
         self.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}


#pragma mark - MKMapViewDelegate

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /**
     *  MKUserLocation大头针模型:描述某一个大头针
     */
    //取出用户的位置
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //改变大头针显示的内容(只需要改变大头针模型属性) 一般根据经纬度进行反地理编码拿到地址然后显示在大头针上
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
         if (placemarks.count == 0 || error)
         {
             return;
         }
         else
         {
             CLPlacemark * pm = placemarks.firstObject;
             if (pm.locality)
             {
                 userLocation.title = pm.locality;
             }
             //是否展示subtitle city的时候不展示
             if (_mapSpan == MapSpanStreet)
             {
                 userLocation.subtitle = pm.name;
             }
         }
     }];
}

/**
 *  每添加一个大头针就会执行该方法
 *  @param annotation 大头针模型对象
 *  @return 大头针的view (返回nil表示默认使用系统的 默认系统大头针MKAnnotationView是不可见的 MKPinAnnotationView才是可见的)
 */
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //创建自定义大头针(可以从缓存池取出)
    static NSString *reuseId = @"OVAlertMapAnnotation";
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!aView)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:reuseId];//这里大头针传nil是因为下面还需要设置
        //使用自定义大头针默认标题和子标题是不显示的 需要设置canShowCallout属性
        aView.canShowCallout = YES;
        //设置大头针颜色 (MKPinAnnotationView这个子类的属性)
        aView.pinTintColor = DEF_BASE_COLOR;
        //设置大头针的掉落效果
        aView.animatesDrop = YES;
    }
    aView.annotation = annotation;
    return aView;
}


#pragma mark - tableView delegate

/**
 *  点选的row
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:NULL animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self hideAndRemove];
    
    if (_alertActionWithTitle)
    {
        _alertActionWithTitle(_actionNames[indexPath.row]);
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
    
    if (_title.length == 0 && _message.length == 0)
    {
        
    }
    else
    {
        //上
        UIView *lineView0 = [[UIView alloc] init];
        if (indexPath.row == 0) // 上线粗点 要不然显示不出来 因为下面的都是上0.25+下0.25 第一行没有上面底的0.25 所以直接用0.5
        {
            lineView0.frame = CGRectMake(0, 0, kBgViewWidth * DEF_DEVICE, kLineHeightX);
        }
        else
        {
            lineView0.frame = CGRectMake(0, 0, kBgViewWidth * DEF_DEVICE, kLineHeight);
        }
        
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


#pragma mark - 点击事件

//地图的归位按钮
- (void) myLocationButtonClick
{
    MKCoordinateSpan span = MKCoordinateSpanMake(_span, _span);
    MKCoordinateRegion regin = MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span);//第二个参数是跨度 也是一个结构体
    [self.mapView setRegion:regin animated:YES];
//    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void) closeButtonClick
{
    
    
    [self myLocationButtonClick];
    
    WeakSelf(weakSelf);
    
    [UIView animateWithDuration:kTimeInterval animations:
     ^{
         weakSelf.mapView.alpha = 0;
         weakSelf.myLocationButton.alpha = 0;
         weakSelf.closeButton.alpha = 0;
    }
                     completion:^(BOOL finished)
     {
         [weakSelf.myLocationButton removeFromSuperview];
         [weakSelf.closeButton removeFromSuperview];
         
         [UIView animateWithDuration:kTimeInterval animations:
          ^{
              weakSelf.mapView.frame = weakSelf.mapViewFrame;
              [weakSelf.bgView addSubview:weakSelf.mapView];
              weakSelf.bgView.alpha = 1.00f;
              weakSelf.mapView.alpha = 1.00f;
         }
                          completion:^(BOOL finished)
          {
              
         }];
    }];
}

- (void) leftButtonClick
{
    [self hideAndRemove];
    
    if (_alertActionWithTitle)
    {
        _alertActionWithTitle(_actionNames[0]);
    }
}

- (void) rightButtonClick
{
    [self hideAndRemove];
    
    if (_alertActionWithTitle)
    {
        _alertActionWithTitle(_actionNames[1]);
    }
}


#pragma mark - dealloc

- (void) dealloc
{
    [self.mapView setShowsUserLocation:NO];
}

@end
