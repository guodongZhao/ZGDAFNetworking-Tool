//
//  HttpTool.m
//
//
//  Created by guodongzhao on 16/3/5.
//  Copyright © 2016年 . All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

#warning 请设置服务器地址
static NSString *const kBaseURLString = @"http://iappfree.candou.com:8080";

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
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure {
    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    // 实例化请求
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    if (error) failure(error);
    
    // 开始获取数据
    [[[AFHttpClient sharedClient] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }
        else {
            success(responseObject);
        }
    }] resume];
    
    // 弃用 2.6
//    [[AFHttpClient sharedClient] POST:path parameters:params success:^(NSURLSessionDataTask *task, id JSON) {
//        
//        if (success == nil) return;
//        success(JSON);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (failure == nil) return;
//        failure(error);
//        
//    }];
}

#pragma mark GET请求
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure
{
    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    // 实例化请求
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:params error:&error];
    if (error) failure(error);

    // 开始获取数据
    [[[AFHttpClient sharedClient] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }
        else {
            success(responseObject);
        }
    }] resume];
    
    // 弃用 2.6
//    [[AFHttpClient sharedClient] GET:path parameters:params success:^(NSURLSessionDataTask *task, id JSON) {
//        
//        if (success == nil) return;
//        success(JSON);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        if (failure == nil) return;
//        failure(error);
//        
//    }];
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
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSUInteger idx = 0; idx < images.count; idx ++) {
            // 获取图片名称
            NSDate *date = [NSDate new];
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyyMMddHHmmss"];
            NSString *time = [df stringFromDate:date];
            NSString *imageName = [NSString stringWithFormat:@"%@%zi.jpg", time, idx + 1];
            
            /*userfile 根据对应请求图片来修改*/
            NSString *name = [NSString stringWithFormat:@"userfile%02zi", idx];
            // 添加图片
            [formData appendPartWithFileData:images[idx] name:name fileName:imageName mimeType:@"image/jpg"];
            
//            formData appendPartWithFileURL:<#(nonnull NSURL *)#> name:<#(nonnull NSString *)#> fileName:<#(nonnull NSString *)#> mimeType:<#(nonnull NSString *)#> error:<#(NSError *__autoreleasing  _Nullable * _Nullable)#>
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

@end
