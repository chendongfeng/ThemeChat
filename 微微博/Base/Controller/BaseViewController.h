//
//  BaseViewController.h
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
@interface BaseViewController : UIViewController

- (void)setNavItem;
//自己实现加载提示
- (void)showLoading:(BOOL)show;


//第三方 MBProgressHUD

- (void)showHUD:(NSString *)title;

- (void)hideHUD;
- (void)completeHUD:(NSString *)title;


- (void)setBgImage;

//状态栏 提示
- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
            operation:(AFHTTPRequestOperation *)operation;

@end
