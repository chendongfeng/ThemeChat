//
//  FansViewController.m
//  微微博
//
//  Created by cdf on 15/10/24.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "FansViewController.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "DataService.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

@interface FansViewController ()
{
    UserModel *_user;
    NSArray *_userArray;
    UICollectionView *_collectionView;
}

@end

@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"粉丝列表";
    [self _loadData];
    [self _createCollectionView];
    
    // Do any additional setup after loading the view.
}

- (void)_loadData {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    [DataService requestAFUrl:@"friendships/followers.json" httpMethod:@"GET" params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"] data:nil block:^(id result) {
        
        _userArray = [result objectForKey:@"users"];
        for (NSDictionary *dic in _userArray) {
            
            _user = [[UserModel alloc] initWithDataDic:dic];
            
        }
        
        [_collectionView reloadData];
    }];
    
    
}

- (void)_createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    layout.itemSize = CGSizeMake(60, 60);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"fansCell"];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _userArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fansCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_user.profile_image_url]];
    [cell.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 10)];
    
    label.font = [UIFont systemFontOfSize:10];
    label.text = _user.screen_name;
    [cell.contentView addSubview:label];
    
    
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = NO;
    
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

@end
