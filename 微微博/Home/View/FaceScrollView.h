//
//  FaceScrollView.h
//  微微博
//
//  Created by cdf on 15/10/23.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
@interface FaceScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    FaceView *_faceView;
}

- (void)setFaceViewDelegate:(id<FaceViewDelegate>)delegate;

@end
