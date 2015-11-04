//
//  UserView.h
//  微微博
//
//  Created by cdf on 15/10/17.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"

@interface UserView : UIView

@property (nonatomic,strong) WeiboModel *weiboModel;

@property (nonatomic,weak) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end
