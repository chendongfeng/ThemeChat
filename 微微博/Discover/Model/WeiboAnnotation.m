//
//  WeiboAnnotation.m
//  微微博
//
//  Created by cdf on 15/10/20.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel = weiboModel;
    NSDictionary *geo = weiboModel.geo;
    
    
    NSArray *coordinates = [geo objectForKey:@"coordinates"];
    if (coordinates.count >= 2) {
        NSString *longitude = coordinates[0];
        NSString *latitude = coordinates[1];
        //设置坐标
        _coordinate = CLLocationCoordinate2DMake([longitude floatValue], [latitude floatValue]);
    }
    
    
    
}

@end
