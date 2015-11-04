//
//  ProfileViewController.h
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeibo.h"
@interface ProfileViewController : BaseViewController<SinaWeiboRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *instroductionLabel;

@property (weak, nonatomic) IBOutlet UILabel *attentionNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *materialButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIView *topView;

- (IBAction)attentionAction:(UIButton *)sender;

- (IBAction)fansAction:(UIButton *)sender;


@end
