//
//  LocViewController.h
//  微微博
//
//  Created by cdf on 15/10/20.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"
#import  <CoreLocation/CoreLocation.h>
#import "PoiModel.h"

@interface LocViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    CLLocationManager *_locationManager;
}
@property (nonatomic ,strong) NSArray *dataList;


@end
