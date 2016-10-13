//
//  HttpTool.m
//
//  https://github.com/guodongZhao/ZGDAFNetworking-Tool.git
//  Created by zhaoguodong on 16/3/5.
//  Copyright © 2016年 bjqttd All rights reserved.
//  https://github.com/guodongZhao.

#import "HttpTool.h"
#import "AFNetworking.h"

#import "ZGDHUD.h"

#warning 请设置服务器地址
static NSString *const kBaseURLString = @"http://(域名)例如：'iappfree.candou.com':(端口号)'例如：8080'";

@interface AFHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFHttpClient

+ (instancetype)sharedClient
{
    static AFHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sharedClient = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString] sessionConfiguration:configuration];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end

@implementation HttpTool

#pragma mark - AFN网络请求
#pragma mark POST请求
+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             hudView:(UIView *)hudView
             hudText:(NSString *)hudText
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure{

    // 初始化HUD
    ZGDHUD *HUDView = [[ZGDHUD alloc] init];
    [HUDView showLoadingHUDAtView:hudView];

    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    // 实例化请求
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    if (error) failure(error);
    
    // 开始获取数据
    [[[AFHttpClient sharedClient] dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//        uploadProgressTool(uploadProgress.fractionCompleted);
//        NSLog(@"开始上传");
 
        // 上传
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//        downloadProgressTool(downloadProgress.fractionCompleted);
//        NSLog(@"开始下载");
//            [HUDView showLoadingHUDAtView:hudView];
        // 下载
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
            [HUDView hide];
            
            ZGDHUD *failHUD = [[ZGDHUD alloc] init];
            [failHUD showFailHUDAtView:hudView];
            
            // 重新加载
            [failHUD setFailBlock:^{
                 __weak typeof(self) weakSelf= self;
                [weakSelf postWithPath:path params:params hudView:hudView hudText:nil success:success failure:failure];
                
//                [failHUD hide];
            }];
//            NSLog(@"网络连接失败失败 错误码%zd", error.code);
            [NSThread sleepForTimeInterval:2.0];
            
        }
        else {
            success(responseObject);
            [NSThread sleepForTimeInterval:0.25];
            [HUDView hide];
//            NSLog(@"网络连接成功");
            
        }
    }] resume];
    
}

#pragma mark GET请求
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            hudView:(UIView *)hudView
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure
{
    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    // 实例化请求
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:params error:&error];
    if (error) failure(error);
    // 初始化HUD
    ZGDHUD *HUDView = [[ZGDHUD alloc] init];
    [HUDView showLoadingHUDAtView:hudView];
    // 开始获取数据
    [[[AFHttpClient sharedClient] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
            [HUDView hide];
            
            ZGDHUD *failHUD = [[ZGDHUD alloc] init];
            [failHUD showFailHUDAtView:hudView];
            
            // 重新加载
            [failHUD setFailBlock:^{
                __weak typeof(self) weakSelf= self;
                [weakSelf postWithPath:path params:params hudView:hudView hudText:nil success:success failure:failure];
                
                //                [failHUD hide];
            }];
            //            NSLog(@"网络连接失败失败 错误码%zd", error.code);
            [NSThread sleepForTimeInterval:2.0];
        }
        else {
            success(responseObject);
        }
    }] resume];
    

}

#pragma mark - POST上传图片
+ (void)postWithImgPath:(NSString *)path
                 params:(NSDictionary *)params
                 images:(NSArray *)images
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure
               progress:(HttpUploadProgressBlock)progress

{
    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    
    // 实例化请求
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSUInteger idx = 0; idx < images.count; idx ++) {
            // 获取图片名称
//            NSDate *date = [NSDate new];
//            NSDateFormatter *df = [[NSDateFormatter alloc]init];
//            [df setDateFormat:@"yyyyMMddHHmmss"];
//            NSString *time = [df stringFromDate:date];
//            NSString *imageName = [NSString stringWithFormat:@"%@%zi.jpg", time, idx + 1];
            /*userfile 根据对应请求图片来修改*/
            NSString *name = [NSString stringWithFormat:@"userfile%02zi", idx];
            NSData *data = image2Data(images[idx], 0.5);
            // 添加图片
            [formData appendPartWithFileData:data name:name fileName:@"headPicture.png" mimeType:@"image/jpg"];
            
        }
    } error:nil];
    if (error) failure(error);
    
    
    // 开始上传图片
    [[[AFHttpClient sharedClient] uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        // 返回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 图片上传进度
            progress(uploadProgress.fractionCompleted);
        });
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }
        else {
            success(responseObject);
        }
    }] resume];
}

#pragma mark - 文件下载
+ (void)dowloadWithPath:(NSString *)path
                success:(HttpDowloadBlock)success
                failure:(HttpFailureBlock)failure
               progress:(HttpDowloadProgressBlock)progress
{
    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    
    // 实例化请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    // 开始下载
    [[[AFHttpClient sharedClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(downloadProgress.fractionCompleted);
        });

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 设置文件的保存地址
        NSURL *cacheUrl = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [cacheUrl URLByAppendingPathComponent:[response suggestedFilename]];
        return cacheUrl;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 文件下载并保存成功后的回调
        if (error) {
            failure(error);
        }
        else {
            success(filePath.path);
        }
    }] resume];
}


#pragma mark - POST上传视频
+ (void)postWithImgPath:(NSString *)path
                 params:(NSDictionary *)params
                 video:(NSArray *)video
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure
               progress:(HttpUploadProgressBlock)progress

{
    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    // 实例化请求
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSUInteger idx = 0; idx < video.count; idx ++) {
            if (idx == 1) {
                [formData appendPartWithFileData:video[idx] name:@"info_video" fileName:@"info_video.MP4" mimeType:@"video/mp4"];
            }else{
                /*userfile 根据对应请求图片来修改*/
                NSData *data = image2Data(video[idx], 0.5);
                [formData appendPartWithFileData:data name:@"info_video_poster" fileName:@"headPicture.png" mimeType:@"image/jpg"];
            }
            }
    } error:nil];
    if (error) failure(error);
    
    // 开始上传图片
    [[[AFHttpClient sharedClient] uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        // 返回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 图片上传进度
            progress(uploadProgress.fractionCompleted);
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }
        else {
            success(responseObject);
        }
    }] resume];
}


#pragma mark -隐藏多余分割线

+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}

@end
