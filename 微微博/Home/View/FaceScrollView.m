//
//  FaceScrollView.m
//  微微博
//
//  Created by cdf on 15/10/23.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "FaceScrollView.h"

@implementation FaceScrollView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setFaceViewDelegate:(id<FaceViewDelegate>)delegate {
    
    _faceView.delegate = delegate;
    
}

- (void)_createView {
    
    _faceView = [[FaceView alloc] initWithFrame:CGRectZero];
    _faceView.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _faceView.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_faceView.width, _faceView.height);
    //子视图超出父视图的部分不剪裁
    _scrollView.clipsToBounds = NO;
    _scrollView.delegate = self;
    
    [_scrollView addSubview:_faceView];
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), kScreenWidth, 20)];
    
    _pageControl.numberOfPages = _faceView.pageNumber;
    _pageControl.currentPage = 0;
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_pageControl];
    
    
    CGRect frame = self.frame;
    frame.size.width = _scrollView.width;
    frame.size.height = CGRectGetHeight(_scrollView.frame) + CGRectGetHeight(_pageControl.frame);
    self.frame = frame;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
    
    
}

- (void)drawRect:(CGRect)rect {
    
    [[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
    
}



@end
