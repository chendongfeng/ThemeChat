//
//  ThemeImageView.m
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotificationName object:nil];
        
    }
    return self;
    
}

- (void)setImageName:(NSString *)imageName{
    
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        [self loadImage];
    }
    
}

- (void)themeDidChange:(NSNotification *)notification {
    
    [self loadImage];
}

- (void)loadImage {
    
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:self.imageName];
    
    UIImage *tempImage = [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapWidth];
    
    if (image != nil) {
        self.image = tempImage;
    }
    
}
@end
