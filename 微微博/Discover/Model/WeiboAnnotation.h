//
//  WeiboAnnotation.h
//  微微博
//
//  Created by cdf on 15/10/20.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "WeiboModel.h"

@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@property (nonatomic,strong) WeiboModel *weiboModel;


@end
