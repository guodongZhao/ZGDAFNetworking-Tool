//
//  GDHUDView-Tool.h
//  ZGHUDProgress
//
//  Created by 赵国栋 on 16/8/2.
//  Copyright © 2016年 赵国栋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FailHUDBlock)(void);

typedef NS_ENUM(NSUInteger, ZGDHUDLoadTypeStyle) {
    LoadProgressHUD_Upload      = 0,   // 上传状态
    LoadProgressHUD_Download    = 1    // 下载状态
};

@interface ZGDHUD : UIView

@property (nonatomic, copy) FailHUDBlock failBlock;


#pragma mark -
#pragma mark 单例模式-GCD(方法声明)-- .h
+ (ZGDHUD *)shareHUDView;
#pragma mark -
#pragma mark Method
/**
 *  状态：加载（显示动图 + 固定文字）
 *
 *  @param HUDView 根视图 如果添加在window上 使用Nil
 */
-(void)showLoadingHUDAtView:(UIView *)HUDView;
/**
 *  状态：上传/下载（显示动图 + progress文字显示）
 *
 *  @param HUDView 根视图 如果添加在window上 使用Nil
 *  @param hudType 上传/下载状态  根据状态改变文字显示
 */
-(void)showLoadProgressHUDAtView:(UIView *)HUDView WithLoadType:(ZGDHUDLoadTypeStyle)hudType WithProgress:(CGFloat)proress;
/**
 *  隐藏
 */
-(void)hide;
/**
 *  状态：加载失败
 *
 *  @param HUDView 根视图 如果添加在window上 使用Nil
 */
-(void)showFailHUDAtView:(UIView *)HUDView;
/**
 *  状态：加载成功
 *
 *  @param HUDView 根视图 如果添加在window上 使用Nil
 */
-(void)showSuccessHUDAtView:(UIView *)HUDView;
@end
