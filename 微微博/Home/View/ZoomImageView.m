//
//  ZoomImageView.m
//  微微博
//
//  Created by cdf on 15/10/17.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "ZoomImageView.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"
@implementation ZoomImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    
    return self;
}
- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    
    return self;
}

- (void)_initTap {
    //01 打开交互
    //02 创建单击手势
    //03 imageView 图片显示模式  保持比例
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    
}
- (void)_createGifIcon {
    
    //创建GIF图标
    _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconView.hidden = YES;
    _iconView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_iconView];
    
}


- (void)zoomIn {
    //调用代理方法，通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    
    self.hidden = YES;
    
    [self _createView];
    
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    //03 添加动画，放大
    [UIView animateWithDuration:0.3 animations:^{
        _fullImageView.frame = _scrollView.frame;
    } completion:^(BOOL finished) {
        _fullImageView.backgroundColor = [UIColor blackColor];
        [self _downloadImage];
    }];
    
    
}

- (void)_downloadImage {
    
    if (self.fullImageUrlString.length > 0) {
        if (_hud == nil) {
            _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
        }
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        
        NSURL *url = [NSURL URLWithString:_fullImageUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
}

- (void)zoomOut {
    
    //调用代理的方法 通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    
    [_connection cancel];
    self.hidden = NO;
    
    _fullImageView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        _fullImageView.top += _scrollView.contentOffset.y;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        _hud = nil;
    }];
    
}
- (void)_createView{
    if (_scrollView == nil) {
        //01 创建scrollView 添加到window上
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
        //02 创建大图 fullImageView;
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
        //03 添加缩小手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        
        //04 长按 保存
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
        // longPress.minimumPressDuration = 1.5;
        [_scrollView addGestureRecognizer:longPress];
        
    }
    
    
}
#pragma mark - 保存图片到相册

- (void)savePhoto:(UILongPressGestureRecognizer *)longPress{
    //
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        //弹出提示框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        UIImage *img = _fullImageView.image;
        
        //  将大图图片保存到相册
        //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}
//保存成功调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    //提示保存成功
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
    
    
}




#pragma mark - 网络下载

//服务器响应请求
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //01 取得响应头
    NSDictionary *headerFields = [httpResponse allHeaderFields];
    
    //02 获取文件大小
    NSString *lengthStr = [headerFields objectForKey:@"Content-Length"];
    _length = [lengthStr doubleValue];
    
    _data = [[NSMutableData alloc] init];
    //   NSLog(@"%@",headerFields);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_data appendData:data];
    CGFloat progress = _data.length/_length;
    _hud.progress = progress;
    NSLog(@"进度 %f",progress);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"下载完毕");
    [_hud hide:YES];
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    
    //尺寸处理
    // kScreenWidth/length = image.size.width/image.size.height
    
    CGFloat length = image.size.height/image.size.width * kScreenWidth;
    if (length > kScreenHeight) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
            
        }];
        
    }
    if (self.isGif) {
        [self gifImageShow];
    }
    
}
- (void)gifImageShow {
    
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    
}



@end
