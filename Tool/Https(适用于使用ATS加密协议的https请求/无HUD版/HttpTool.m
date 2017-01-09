//
//  HttpTool.m
//
//  https://github.com/guodongZhao/ZGDAFNetworking-Tool.git
//  Created by zhaoguodong on 16/3/5.
//  Copyright © 2016年 bjqttd All rights reserved.
//  https://github.com/guodongZhao.

#import "HttpTool.h"
#import "AFNetworking.h"


#warning 请设置服务器基地址
static NSString *const kBaseURLString = @"服务器基地址 例如:https://baidu.com/api/";
static inline NSData * image2Data(UIImage *img,CGFloat num) {
    NSData *d = UIImageJPEGRepresentation(img,num);
    if (d == nil) {
        d = UIImageJPEGRepresentation(img, num);
    }
    return d;
}


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
        // /先导入证书
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"此处为证书文件名" ofType:@"cer"];//证书的路径  PS：使用时请将CA认证机构证书放在项目路径中
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        // AFSSLPinningModeCertificate 使用证书验证模式
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        _sharedClient.securityPolicy.validatesDomainName = NO;
        
        _sharedClient.securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
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
    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    // 实例化请求
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:&error];
    if (error) failure(error);
    
    // 开始获取数据
    [[[AFHttpClient sharedClient] dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        //        uploadProgressTool(uploadProgress.fractionCompleted);
        NSLog(@"开始上传");
        
        // 上传
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        //        downloadProgressTool(downloadProgress.fractionCompleted);
        NSLog(@"开始下载");
        // 下载
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
            
            NSLog(@"网络连接失败失败 错误码%zd", error.code);
            
            
        }
        else {
            success(responseObject);
            
            NSLog(@"网络连接成功");
            
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
    // 开始获取数据
    [[[AFHttpClient sharedClient] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
            
            NSLog(@"网络连接失败失败 错误码%zd", error.code);
            
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
+(void)postWithVideoPath:(NSString *)path
                  params:(NSDictionary *)params
                   video:(NSData *)video
              videoImage:(NSData *)videoImage
    videoImageParamsName:(NSString *)VideoParamsImageName
         videoParamsName:(NSString *)VideoParamsName
                 hudView:(UIView *)hudView
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpUploadProgressBlock)progress
{
    // 获取完整的URL
    NSString *urlString = [kBaseURLString stringByAppendingPathComponent:path];
    // 实例化请求
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (video != nil) {
            [formData appendPartWithFileData:video name:VideoParamsName fileName:[NSString stringWithFormat:@"%@.mp4", VideoParamsName] mimeType:[NSString stringWithFormat:@"%@/mp4", VideoParamsName]];
        }
        if (videoImage != nil) {
            [formData appendPartWithFileData:videoImage name:VideoParamsImageName fileName:[NSString stringWithFormat:@"%@.jpg", VideoParamsImageName] mimeType:[NSString stringWithFormat:@"%@/jpg", VideoParamsImageName]];
        }
    } error:nil];
    if (error) failure(error);
    // 开始上传
    [[[AFHttpClient sharedClient] uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        // 返回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 上传进度
            progress(uploadProgress.fractionCompleted);
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
            NSLog(@"网络连接失败失败 错误码%zd", error.code);
            [NSThread sleepForTimeInterval:2.0];
            
            
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
