//
//  WeiboCell.h
//  微微博
//
//  Created by cdf on 15/10/13.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "WeiboViewLayoutFrame.h"

@interface WeiboCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *rePostLabel;
@property (weak, nonatomic) IBOutlet UILabel *srcLabel;

@property (strong,nonatomic) WeiboView *weiboView;
@property (nonatomic,strong) WeiboViewLayoutFrame *layoutFrame;

@end
