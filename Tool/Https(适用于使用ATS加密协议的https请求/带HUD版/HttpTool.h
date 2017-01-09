//
//  HttpTool.h
//
//  https://github.com/guodongZhao/ZGDAFNetworking-Tool.git
//  Created by zhaoguodong on 16/3/5.
//  Copyright © 2016年 bjqttd All rights reserved.
//  https://github.com/guodongZhao.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HttpSuccessBlock) (NSDictionary * JSONDic);
typedef void (^HttpFailureBlock) (NSError *error);
typedef void (^HttpUploadProgressBlock) (CGFloat progress);
typedef void (^HttpDowloadBlock) (NSString *filePath);
typedef void (^HttpDowloadProgressBlock) (CGFloat progress);

@interface HttpTool : NSObject


/**
 *  AFN get请求
 *
 *  @param path     URL地址
 *
 *  @param params   请求参数 (NSDictionary)
 *
 *  @param hudView  加载动画的根视图(无需求时可传nil)
 *
 *  @param success  请求成功返回值（NSArray or NSDictionary）
 *
 *  @param failure  请求失败值 (NSError)
 */
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            hudView:(UIView *)hudView
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;

/**
 *  AFN post请求
 *
 *  @param path     URL地址
 *
 *  @param params   请求参数 (NSDictionary)
 *
 *  @param hudView  加载动画的根视图(无需求时可传nil)
 *
 *  @param hudText  加载动画的文字显示(无需求时可传nil)
 *
 *  @param success  请求成功返回值（NSArray or NSDictionary）
 *
 *  @param failure  请求失败值 (NSError)
 */
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             hudView:(UIView *)hudView
             hudText:(NSString *)hudText
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;


/**
 *  AFN POST上传图片
 *
 *  @param path     URL地址
 *
 *  @param params   请求参数 (NSDictionary)
 *
 *  @param success  请求成功返回值（NSArray or NSDictionary）
 *
 *  @param progress 图片上传进度（浮点型）
 *
 *  @param images   需要上传的图片数组，二进制格式的图片
 *
 *  @param failure  请求失败值 (NSError)
 */
+ (void)postWithImgPath:(NSString *)path
                 params:(NSDictionary *)params
                 images:(NSArray *)images
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure
               progress:(HttpUploadProgressBlock)progress;

/**
 *  AFN 下载文件
 *
 *  @param path     URL地址
 *
 *  @param success  文件下载成功回调（下载文件保存路径）
 *
 *  @param progress 文件下载进度（浮点型）
 *
 *  @param failure  请求失败值 (NSError)
 */
+ (void)dowloadWithPath:(NSString *)path
                success:(HttpDowloadBlock)success
                failure:(HttpFailureBlock)failure
               progress:(HttpDowloadProgressBlock)progress;

/**
 *  AFN 上传视频+图片(可单独传视频或图片)
 *
 *  ps:图片和视频皆为NSData格式 请提前压缩文件 单传另一项参数和文件传nil
 *
 *  @param path                  URL地址
 *
 *  @param params                参数集 (同时上传的其他参数)
 *
 *  @param video                 用于存放视频 二进制Data类型
 *
 *  @param videoImage            用于存放帧图片 二进制Data类型
 *
 *  @param VideoParamsImageName  视频帧图片(占位图)的参数名
 *
 *  @param VideoParamsName       视频参数名
 *
 *  @param hudView               加载动画的根视图(无需求时可传nil)
 *
 *  @param success               文件下载成功回调（下载文件保存路径）
 *
 *  @param progress              文件下载进度（浮点型）
 *
 *  @param failure               请求失败值 (NSError)
 */
+(void)postWithVideoPath:(NSString *)path
                  params:(NSDictionary *)params
                   video:(NSData *)video
              videoImage:(NSData *)videoImage
    videoImageParamsName:(NSString *)VideoParamsImageName
         videoParamsName:(NSString *)VideoParamsName
                 hudView:(UIView *)hudView
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpUploadProgressBlock)progress;




/**
 *  UITableView 隐藏多余分割线
 *
 *  @param tableView 需要隐藏分割线的tableView
 */
+(void)setExtraCellLineHidden: (UITableView *)tableView;
@end
