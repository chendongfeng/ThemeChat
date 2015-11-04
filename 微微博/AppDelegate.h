//
//  AppDelegate.h
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SinaWeibo *sinaWeibo;

@end

