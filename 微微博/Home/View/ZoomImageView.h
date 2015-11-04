//
//  ZoomImageView.h
//  微微博
//
//  Created by cdf on 15/10/17.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class ZoomImageView;


//定义协议，当图片放大或缩小的时候调用
@protocol ZoomImageViewDelegate <NSObject>
@optional

//图片将要放大

- (void)imageWillZoomIn:(ZoomImageView *)imageView;

//将要缩小
- (void)imageWillZoomOut:(ZoomImageView *)imageView;
//已经放大
//已经缩小
//....

@end


@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate>{
    
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    NSURLConnection *_connection;
    double _length;
    NSMutableData *_data;
    MBProgressHUD *_hud;
    
}
@property (nonatomic,assign) BOOL isGif;
@property (nonatomic,strong) UIImageView  *iconView;
@property (nonatomic,strong) NSString *fullImageUrlString;
@property (nonatomic,weak) id<ZoomImageViewDelegate> delegate;

@end
