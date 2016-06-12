//
//  HttpTool.h
//  
//
//  Created by guodongzhao on 16/3/5.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HttpSuccessBlock) (id JSON);
typedef void (^HttpFailureBlock) (NSError *error);
typedef void (^HttpUploadProgressBlock) (CGFloat progress);
typedef void (^HttpDowloadBlock) (NSString *filePath);
typedef void (^HttpDowloadProgressBlock) (CGFloat progress);

@interface HttpTool : NSObject


/**
 *  AFN get请求
 *
 *  @param path URL地址
 *
 *  @param params 请求参数 (NSDictionary)
 *
 *  @param success 请求成功返回值（NSArray or NSDictionary）
 *
 *  @param failure 请求失败值 (NSError)
 */
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;

/**
 *  AFN post请求
 *
 *  @param path URL地址
 *
 *  @param params 请求参数 (NSDictionary)
 *
 *  @param success 请求成功返回值（NSArray or NSDictionary）
 *
 *  @param failure 请求失败值 (NSError)
 */
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;


/**
 *  AFN POST上传图片
 *
 *  @param path URL地址
 *
 *  @param params 请求参数 (NSDictionary)
 *
 *  @param success 请求成功返回值（NSArray or NSDictionary）
 *
 *  @param progress 图片上传进度（浮点型）
 *
 *  @param images 需要上传的图片数组，二进制格式的图片
 *
 *  @param failure 请求失败值 (NSError)
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
 *  @param path URL地址
 *
 *  @param success 文件下载成功回调（下载文件保存路径）
 *
 *  @param progress 文件下载进度（浮点型）
 *
 *  @param failure 请求失败值 (NSError)
 */
+ (void)dowloadWithPath:(NSString *)path
                success:(HttpDowloadBlock)success
                failure:(HttpFailureBlock)failure
               progress:(HttpDowloadProgressBlock)progress;



@end
