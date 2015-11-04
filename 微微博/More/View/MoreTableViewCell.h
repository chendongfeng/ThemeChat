//
//  MoreTableViewCell.h
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"
#import "ThemeLabel.h"
#import "ThemeImageView.h"


@interface MoreTableViewCell : UITableViewCell

//为了实现 主题的切换
@property(nonatomic,strong)ThemeImageView *themeImageView;
@property(nonatomic,strong)ThemeLabel *themeTextLabel;
@property(nonatomic,strong)ThemeLabel *themeDetailLabel;

@end
