//
//  MoreViewController.h
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : BaseViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end
