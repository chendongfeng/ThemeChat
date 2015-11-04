//
//  HomeViewController.m
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "HomeViewController.h"
#import "ThemeManager.h"
#import "AppDelegate.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WeiboViewLayoutFrame.h"
#import "MJRefresh.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ThemeLabel.h"
#import "ThemeImageView.h"

@interface HomeViewController ()
{
    WeiboTableView *_weiboTable;
    NSMutableArray *_data;
    
    ThemeImageView *_barImageView;
    ThemeLabel *_barLabel;
}
@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] init];
    [self setNavItem];
    
    //创建微博列表
    [self _createTable];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [self _loadWeiboData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - tableView创建
- (void)_createTable{
    
    _weiboTable = [[WeiboTableView alloc] initWithFrame:self.view.bounds];
    _weiboTable.backgroundColor = [UIColor clearColor];
    // _weiboTable.hidden = YES;
    
    //设置内容偏移
    
    [self.view addSubview:_weiboTable];
    
    _weiboTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    
    _weiboTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
    
}

#pragma mark - 微博请求

- (void)_loadWeiboData{
    
    [self showHUD:@"正在加载。。。"];
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    //如果已经登陆则获取微博数据
    if (appDelegate.sinaWeibo.isLoggedIn) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        
        SinaWeiboRequest *request =  [appDelegate.sinaWeibo requestWithURL:home_timeline
                                                                    params:params
                                                                httpMethod:@"GET"
                                                                  delegate:self];
        
        
        request.tag = 100;
        
        return;
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
}

//上拉加载更多
- (void)_loadMoreData{
    
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //如果已经登陆则获取微博数据
    if (appDelegate.sinaWeibo.isLoggedIn) {
        
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        
        //设置maxId
        
        if (_data.count != 0) {
            WeiboViewLayoutFrame *layoutFrame = [_data lastObject];
            WeiboModel *model = layoutFrame.weiboModel;
            NSString *maxId = model.weiboIdStr;
            [params setObject:maxId forKey:@"max_id"];
        }
        
        
        
        SinaWeiboRequest *request = [appDelegate.sinaWeibo requestWithURL:home_timeline
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        
        request.tag = 101;
        
        
        return;
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

//下拉刷新

- (void)_loadNewData{
    
    AppDelegate *appDelegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.sinaWeibo.isLoggedIn) {
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        //设置 sinceId
        if (_data.count != 0) {
            WeiboViewLayoutFrame *layoutFrame = _data[0];
            WeiboModel *model = layoutFrame.weiboModel;
            NSString *sinceId = model.weiboIdStr;
            [params setObject:sinceId forKey:@"since_id"];
        }
        
        
        SinaWeiboRequest *request = [appDelegate.sinaWeibo requestWithURL:home_timeline
                                                                   params:params
                                                               httpMethod:@"GET"
                                                                 delegate:self];
        request.tag = 102;
        
        
        return;
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}


#pragma mark - 网络请求代理
//- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response;
//- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data;
//- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error;

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    
    //每一条微博存到 数组里
    NSArray *dicArray = [result objectForKey:@"statuses"];
    
    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] initWithCapacity:dicArray.count];
    
    //解析model,然后把model存放到dataArray,然后再把dataArray 交给weiboTable;
    
    for (NSDictionary *dataDic in dicArray) {
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dataDic];
        WeiboViewLayoutFrame *layoutFrame = [[WeiboViewLayoutFrame alloc] init];
        layoutFrame.weiboModel = model;
        
        [layoutFrameArray addObject:layoutFrame];
    }
    
    if (request.tag == 100) {//普通加载微博
        [self completeHUD:@"加载完成"];
        _data = layoutFrameArray;
        
    }else if(request.tag == 101){//更多微博
        
        if (layoutFrameArray.count > 1) {
            [layoutFrameArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:layoutFrameArray];
        }
        
        
    }else if(request.tag == 102){//最新微博
        if (layoutFrameArray.count > 0) {
            
            NSRange range = NSMakeRange(0, layoutFrameArray.count);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
            
            [self showNewWeiboCount:layoutFrameArray.count];
        }
        
    }
    
    if (_data.count != 0) {
        _weiboTable.layoutFrameArray = _data;
        [_weiboTable reloadData];
    }
    
    
    [_weiboTable.header endRefreshing];
    [_weiboTable.footer endRefreshing];
    
}

- (void)showNewWeiboCount:(NSInteger)count {
    
    if (_barImageView == nil) {
        
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth - 10, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        _barLabel = [[ThemeLabel alloc] initWithFrame:_barImageView.bounds];
        _barLabel.colorName = @"Timeline_Notice_color";
        _barLabel.backgroundColor = [UIColor clearColor];
        _barLabel.textAlignment = NSTextAlignmentCenter;
        [_barImageView addSubview:_barLabel];
        
        
    }
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        [UIView animateWithDuration:0.5 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 109);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [UIView setAnimationDelay:1];
                _barLabel.transform = CGAffineTransformIdentity;
            }];
        }];
        
        //播放声音
        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        
        //注册系统声音
        SystemSoundID soundId;// 0
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
        AudioServicesPlaySystemSound(soundId);

    }
    
}

@end
