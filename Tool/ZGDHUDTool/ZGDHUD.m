//
//  GDHUDView-Tool.m
//  ZGHUDProgress
//
//  Created by 赵国栋 on 16/8/2.
//  Copyright © 2016年 赵国栋. All rights reserved.
//

#import "ZGDHUD.h"


#import "UIImageView+GIF.h"





@interface ZGDHUD ()

// 动态图
@property (nonatomic, strong) UIImageView *show_ImageView;
// 文字显示
@property (nonatomic, strong) UILabel *message_Label;

// 重新请求需要的请求字典
@property (nonatomic, strong) NSDictionary *paramsDict;


@end

@implementation ZGDHUD
#pragma mark -
#pragma mark message_Label 初始化
- (UILabel *)message_Label
{
    if (!_message_Label) {
        _message_Label = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 100, self.bounds.size.height/2 + 10, 200, 20)];
        _message_Label.text = @"正在加载中...";
        _message_Label.textAlignment = NSTextAlignmentCenter;
        _message_Label.font = [UIFont boldSystemFontOfSize:15];
        
        [self addSubview:_message_Label];
    }
    return _message_Label;
}

#pragma mark -
#pragma mark 单例模式-GCD(方法声明)-- .m
+ (ZGDHUD *)shareHUDView
{
    static ZGDHUD *shareHUDView = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareHUDView = [[self alloc] initWithFrame:KLastWindow.bounds];
        shareHUDView.backgroundColor = [UIColor whiteColor];
    });
    return shareHUDView;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = KLastWindow.bounds;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -
#pragma mark lifecycle
- (void)drawRect:(CGRect)rect {
//    NSLog(@"生命周期");
}
#pragma mark -
#pragma mark class Method
/**
 *  状态：加载（显示动图 + 固定文字）
 *
 *  @param HUDView 根视图 如果添加在window上 使用Nil
 */
-(void)showLoadingHUDAtView:(UIView *)HUDView
{
    
    // 获取图片地址
    NSString *file = [[NSBundle mainBundle] pathForResource:@"40" ofType:@"gif"];
    // 初始化图片
    UIImageView *loadingImageView = [UIImageView imageViewWithGIFFile:file frame:CGRectMake(self.bounds.size.width/2 - 32, self.bounds.size.height/2 - 64, 64, 64)];
    // 添加视图
    [self addSubview:loadingImageView];
    self.message_Label.text = @"正在加载...";
    
    [HUDView addSubview:self];
    
}
/**
 *  状态：上传/下载（显示动图 + progress文字显示）
 *
 *  @param HUDView 根视图 如果添加在window上 使用Nil
 *  @param hudType 上传/下载状态  根据状态改变文字显示
 */
-(void)showLoadProgressHUDAtView:(UIView *)HUDView WithLoadType:(ZGDHUDLoadTypeStyle)hudType WithProgress:(CGFloat)proress
{
    // 获取图片地址
    NSString *file = [[NSBundle mainBundle] pathForResource:@"40" ofType:@"gif"];
    // 初始化图片
    UIImageView *loadingProgressImageView = [UIImageView imageViewWithGIFFile:file frame:CGRectMake(self.bounds.size.width/2 - 32, self.bounds.size.height/2 - 64, 64, 64)];
    // 添加视图
    [self addSubview:loadingProgressImageView];
    self.message_Label.text = [NSString stringWithFormat:@"正在加载中...%.2f %%", proress * 100];
    
    [HUDView addSubview:self];
}
/**
 *  隐藏
 */
-(void)hide
{
    self.hidden = YES;
    [self removeFromSuperview];
}
/**
 *  状态：加载失败
 *
 *  @param HUDView 根视图 如果添加在window上 使用Nil
 */
-(void)showFailHUDAtView:(UIView *)HUDView
{
    
    // 初始化返回按钮
    UIImageView *fanhuiImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 35, 40)];
    fanhuiImage.userInteractionEnabled = YES;
    fanhuiImage.image = [UIImage imageNamed:@"ZGDHUD返回"];
    UITapGestureRecognizer *TapFanHuiGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Action_TapFanHuiGestureButton:)];
    [fanhuiImage addGestureRecognizer:TapFanHuiGesture];
    [self addSubview:fanhuiImage];
    
    // 初始化图片
    UIImageView *failImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 60, self.bounds.size.height/2 - 120, 120, 120)];
    failImageView.image = [UIImage imageNamed:@"failed"];
    
    // 添加视图
    [self addSubview:failImageView];
    self.message_Label.text = @"加载失败...请检查网络";
    
    UIButton *ReloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ReloadButton.frame = CGRectMake(self.bounds.size.width/2 - 75, self.bounds.size.height/2 + 40, 150, 30);
    [ReloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [ReloadButton setBackgroundColor:BackgroundColor];
    [ReloadButton addTarget:self action:@selector(Action_ReloadButton:) forControlEvents:UIControlEventTouchUpInside];
    [ReloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 添加子视图
    [self addSubview:ReloadButton];
    
    [HUDView addSubview:self];
}
/**
 *  状态：加载成功
 *
 *  @param HUDView 根视图 如果添加在window上 使用Nil
 */
-(void)showSuccessHUDAtView:(UIView *)HUDView
{
    // 初始化图片
    UIImageView *successImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 60, self.bounds.size.height/2 - 120, 120, 120)];
    successImageView.image = [UIImage imageNamed:@"null"];
    // 添加视图
    [self addSubview:successImageView];
    self.message_Label.text = @"加载成功";
    
    [HUDView addSubview:self];

}

#pragma mark -
#pragma mark action
- (void)Action_ReloadButton:(UIButton *)button
{
    if (self.failBlock) {
    
        self.failBlock();
        [self hide];
    }
}
// 失败返回
- (void)Action_TapFanHuiGestureButton:(UIButton *)button
{
    NSLog(@"返回");
    [self hide];
}

@end
