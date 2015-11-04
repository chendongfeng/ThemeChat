//
//  WeiboTableView.h
//  微微博
//
//  Created by cdf on 15/10/13.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeiboTableView : UITableView<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong) NSArray  *layoutFrameArray;

@end
