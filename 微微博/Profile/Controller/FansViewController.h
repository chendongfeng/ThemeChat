//
//  FansViewController.h
//  微微博
//
//  Created by cdf on 15/10/24.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeibo.h"

@interface FansViewController : BaseViewController<SinaWeiboRequestDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@end
