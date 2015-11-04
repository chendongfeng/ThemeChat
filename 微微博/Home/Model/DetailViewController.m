//
//  DetailViewController.m
//  微微博
//
//  Created by cdf on 15/10/17.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "CommentTableView.h"
#import "CommentModel.h"
#import "MJRefresh.h"

@interface DetailViewController ()
{
    CommentTableView *_commentTableView;
    
    SinaWeiboRequest *_request;
}

@end

@implementation DetailViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTableView];
    [self _loadData];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    //当界面弹出时，断开网络连接
    [_request disconnect];
    
}

- (void)_createTableView {
    
    _commentTableView = [[CommentTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_commentTableView];

    _commentTableView.weiboModel = self.weiboModel;
    _commentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}
- (void)_loadData {
    
    NSString *weiboID = [self.weiboModel.weiboId stringValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:weiboID forKey:@"id"];
    
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    _request =  [sinaWeibo requestWithURL:comments params:params httpMethod:@"GET" delegate:self];
    _request.tag = 100;
    
}
//加载更多数据
- (void)_loadMoreData{
    NSString *weiboId = [self.weiboModel.weiboId stringValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:weiboId forKey:@"id"];
    
    
    //设置max_id 分页加载
    CommentModel *cm = [self.data lastObject];
    if (cm == nil) {
        return;
    }
    NSString *lastID = cm.idstr;
    [params setObject:lastID forKey:@"max_id"];
    
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    _request =  [sinaWeibo requestWithURL:comments params:params httpMethod:@"GET" delegate:self];
    _request.tag = 102;
    
    
}
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaWeibo;
}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"网络接口 请求成功");
    
    NSArray *array = [result objectForKey:@"comments"];
    
    NSMutableArray *comentModelArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *dataDic in array) {
        CommentModel *commentModel = [[CommentModel alloc]initWithDataDic:dataDic];
        [comentModelArray addObject:commentModel];
    }
    
    
    if (request.tag == 100) {
        self.data = comentModelArray;
        
    }else if(request.tag ==102){//更多数据
        [_commentTableView.footer endRefreshing];
        if (comentModelArray.count > 1) {
            [comentModelArray removeObjectAtIndex:0];
            [self.data addObjectsFromArray:comentModelArray];
        }else{
            return;
        }
    }
    
    _commentTableView.commentDataArray = self.data;
    _commentTableView.commentDic = result;
    [_commentTableView reloadData];
    
    
    
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
