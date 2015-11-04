//
//  SendViewController.h
//  微微博
//
//  Created by cdf on 15/10/19.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"
#import "ZoomImageView.h"
#import <CoreLocation/CoreLocation.h>
#import "FaceScrollView.h"

@interface SendViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,CLLocationManagerDelegate,ZoomImageViewDelegate,FaceViewDelegate>

{
    UIImage *_sendImage;
    
    //1 文本编辑栏
    UITextView *_textView;
    
    //2 工具栏
    UIView *_editorBar;
    
    //3 显示缩略图
    ZoomImageView *_zoomImageView;
    
    //4 位置管理器
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;
    
    
    FaceScrollView *_faceViewPanel;
}

@end
