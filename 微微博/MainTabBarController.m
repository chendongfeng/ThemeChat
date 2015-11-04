//
//  MainTabBarController.m
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "AppDelegate.h"
#import "ThemeLabel.h"
#import "SinaWeibo.h"

@interface MainTabBarController ()
{
    ThemeImageView *_selectedImageView;
    ThemeLabel *_badgeLabel;
    ThemeImageView *_badgeImageView;
    
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createSubControllers];
    
    [self _createTabBar];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createTabBar{
    //01 移除tabBarButton
    //UITabBarButton
    for (UIView *view in self.tabBar.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
    
    //02 tabBar背景图片: 创建imageView 作为 子视图 添加到 tabBar上
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 49)];
    //  bgImageView.image = [UIImage imageNamed:@"Skins/cat/mask_navbar.png"];
    bgImageView.imageName = @"mask_navbar.png";
    [self.tabBar addSubview:bgImageView];
    
    
    //03 选中图片
    _selectedImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/5, 49)];
    // _selectedImageView.image = [UIImage imageNamed:@"Skins/cat/home_bottom_tab_arrow.png"];
    _selectedImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_selectedImageView];
    
    
    //04 tabbar 标签button
    CGFloat itemWidth = kScreenWidth/5;
    //    NSArray *imageNames =@[
    //                           @"Skins/cat/home_tab_icon_1.png",
    //                           @"Skins/cat/home_tab_icon_2.png",
    //                           @"Skins/cat/home_tab_icon_3.png",
    //                           @"Skins/cat/home_tab_icon_4.png",
    //                           @"Skins/cat/home_tab_icon_5.png",
    //                           ];
    //加入主题管家管理图片
    NSArray *imageNames =@[
                           @"home_tab_icon_1.png",
                           @"home_tab_icon_2.png",
                           @"home_tab_icon_3.png",
                           @"home_tab_icon_4.png",
                           @"home_tab_icon_5.png",
                           
                           ];
    
    
    for (int i = 0; i<imageNames.count; i++) {
        
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, 49)];
        
        button.normalImageName = imageNames[i];
        button.tag = i;
        [button addTarget:self action:@selector(_selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
        
        
    }
    
}
- (void)_selectAction:(UIButton *)button{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectedImageView.center = button.center;
    }];
    
    
    
    self.selectedIndex = button.tag;
    
}



- (void)_createSubControllers{
    //
    //    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    //    [storyBoard instantiateInitialViewController];
    NSArray *names = @[@"Home",@"Message",@"Profile",@"Discover",@"More"];
    NSMutableArray *navArray = [[NSMutableArray alloc] initWithCapacity:names.count];
    for ( int i  = 0; i<5; i++) {
        NSString *name = names[i];
        //创建storyBoard对象
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
        
        //通过 storyBoard创建控制器对象
        BaseNavController *navVc = [storyBoard instantiateInitialViewController];
        
        [navArray addObject:navVc];
        
    }
    self.viewControllers = navArray;
    
}

- (void)timerAction:(NSTimer *)timer {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
    

    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSNumber *statuses = [result objectForKey:@"statuses"];
    NSInteger count = [statuses integerValue];
    
    CGFloat tabBarButtonWidth = kScreenWidth/5;
    if (_badgeImageView == nil) {
        _badgeImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(tabBarButtonWidth-32, 0, 32, 32)];
        _badgeImageView.imageName = @"number_notify_9.png";
        [self.tabBar addSubview:_badgeImageView];
        
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeImageView.bounds];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.font =[UIFont systemFontOfSize:13];
        _badgeLabel.colorName = @"Timeline_Notice_color";
        [_badgeImageView addSubview:_badgeLabel];
        
    }
    if (count > 0) {
        _badgeImageView.hidden = NO;
        if (count > 99) {
            count = 99;
        }
        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
    }else{
        
        _badgeImageView.hidden = YES;
        
    }

    
}



@end
