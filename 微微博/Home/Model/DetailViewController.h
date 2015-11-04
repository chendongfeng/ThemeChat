//
//  DetailViewController.h
//  微微博
//
//  Created by cdf on 15/10/17.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "SinaWeibo.h"


@interface DetailViewController : BaseViewController<SinaWeiboRequestDelegate>

@property (nonatomic,strong) WeiboModel *weiboModel;

@property (nonatomic,strong) NSMutableArray *data;


@end
