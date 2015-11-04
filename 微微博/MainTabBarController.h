//
//  MainTabBarController.h
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
@interface MainTabBarController : UITabBarController<SinaWeiboDelegate,SinaWeiboRequestDelegate>

@end
