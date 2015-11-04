//
//  CommentTableView.h
//  微微博
//
//  Created by cdf on 15/10/17.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentCell.h"
#import "UserView.h"

@interface CommentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

{
    //用户视图
    UserView *_userView;
    //微博视图
    WeiboView *_weiboView;
    
    //头视图
    UIView *_theTableHeaderView;
}

@property(nonatomic,strong)NSArray *commentDataArray;
@property(nonatomic,strong)WeiboModel *weiboModel;
@property(nonatomic,strong)NSDictionary *commentDic;

@end
