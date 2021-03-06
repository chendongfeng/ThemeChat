//
//  WeiboTableView.m
//  微微博
//
//  Created by cdf on 15/10/13.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "WeiboViewLayoutFrame.h"
#import "DetailViewController.h"
#import "UIView+ViewController.h"

@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self _initTable];
    }
    return self;
    
}
- (void)awakeFromNib {
    
    [self _initTable];
    
}

- (void)_initTable {
    
    self.dataSource = self;
    self.delegate = self;
    //注册单元格
    UINib *nib  = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    
    
}



#pragma  mark  - table代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _layoutFrameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
    
    //获得 某个cell的布局对象（各个frame  weiboModel）
    WeiboViewLayoutFrame *layoutFrame = _layoutFrameArray[indexPath.row];
    
    cell.layoutFrame = layoutFrame;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell
    //CELL,
    
    //可以提前算出高度,model
    WeiboViewLayoutFrame *layoutFrame = _layoutFrameArray[indexPath.row];
    
    CGFloat height = layoutFrame.frame.size.height;
    
    
    
    return  height + 80;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    
    WeiboViewLayoutFrame *layoutFrame = _layoutFrameArray[indexPath.row];
    vc.weiboModel = layoutFrame.weiboModel;
    
    //通过 view找viewController:原理，事件响应者链
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
    
    
    
    
    
}


@end
