//
//  ProfileViewController.m
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "ProfileViewController.h"
#import "WeiboModel.h"
#import "WeiboViewLayoutFrame.h"
#import "UIImageView+WebCache.h"
#import "WeiboTableView.h"
#import "AppDelegate.h"
#import "FansViewController.h"
#import "AttentionViewController.h"

@interface ProfileViewController ()
{
    WeiboTableView *_tableView;
    WeiboModel *_weiboModel;
    
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topView.backgroundColor = [UIColor clearColor];
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, self.view.frame.size.height - 155) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    [sinaWeibo requestWithURL:@"statuses/user_timeline.json" params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"错误%@",error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSArray *statuses = [result objectForKey:@"statuses"];
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in statuses) {
        
        _weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
        WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
        layout.weiboModel = _weiboModel;
        
        [modelArray addObject:layout];
        
    }
    [self loadData];
    _tableView.layoutFrameArray = modelArray;
    [_tableView reloadData];
    
}

//加载数据
-(void)loadData {
    
    _nickNameLabel.text = _weiboModel.userModel.screen_name;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_weiboModel.userModel.profile_image_url]];
    NSString *cityName = _weiboModel.userModel.location;
    NSString *sex = _weiboModel.userModel.gender;
    
    if ([sex isEqualToString:@"m"]) {
        sex = @"男";
    }else if ([sex isEqualToString:@"w"]) {
        
        sex = @"女";
        
    }else {
        sex = @"未知";
    }
    
    NSString *information = [NSString stringWithFormat:@"%@  %@",sex,cityName];
    _informationLabel.text = information;
    _fansNumberLabel.text = [NSString stringWithFormat:@"%@",_weiboModel.userModel.followers_count];
    _attentionNumberLabel.text = [NSString stringWithFormat:@"%@",_weiboModel.userModel.friends_count];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)attentionAction:(UIButton *)sender {
    
    AttentionViewController *attention = [[AttentionViewController alloc] init];
    [self.navigationController pushViewController:attention animated:YES];
    
}

- (IBAction)fansAction:(UIButton *)sender {
    
    FansViewController *fansView = [[FansViewController alloc] init];
    [self.navigationController pushViewController:fansView animated:YES];
    
    
}
@end
