//
//  NearByViewController.h
//  微微博
//
//  Created by cdf on 15/10/20.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearByViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    
}

@end
