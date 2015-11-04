//
//  LeftViewController.h
//  微微博
//
//  Created by cdf on 15/10/20.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"

@interface LeftViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_sectionTitles;
    NSArray *_rowTitles;
    
}


@end
