# ZGDAFNetworking-Tool
======================
## 基于最新AFN3.1.0二次封装 （Based on the latest AFN3.1.0 secondary packaging）
-----------------------------------------------------------------------------
`持续更新中`    `目前版本1.2.2`

### 功能迭代：版本1.2.2
===========
#### 1.重写上传视频方法，可携带参数集和帧图片(占位图)上传
#### 2.完善重新加载方法
#### 3.完善提醒功能

### 新增功能：版本1.2
===========
#### 1.新增上传视频 音频 二进制文件
#### 2.新增自定义HUD 可替换自定义动图GIF （包含加载成功 加载中 加载失败 进度条等）
#### 3.新增隐藏UITableView 多余分割线


### 使用时请设置服务器地址（域名）
Warning :!!   位于HttpTool.m文件中
----------
```objc
#warning 请设置服务器地址  
static NSString *const kBaseURLString = @"http://(域名)例如：'iappfree.candou.com':(端口号)'例如：8080'";
```
#### `Method`
1.AFN get请求
----------
```objc 
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
            hudView:(UIView *)hudView
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;
```
2.AFN post请求
-------------
```objc
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
             hudView:(UIView *)hudView
             hudText:(NSString *)hudText
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;
```
3.AFN POST上传图片
----------------
```objc
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
```
4.AFN 下载文件
------------
```objc
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
```
5.AFN 上传视频+参数集
------------------
```objc
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
```

6. UITableView 隐藏多余的分割线（新特性）
----------------------------------
```objc
/**
 *  UITableView 隐藏多余分割线
 *
 *  @param tableView 需要隐藏分割线的tableView
 */
+(void)setExtraCellLineHidden: (UITableView *)tableView;
```
