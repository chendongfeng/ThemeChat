//
//  BaseViewController.m
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "BaseViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeManager.h"
#import "UIProgressView+AFNetworking.h"

#import "ThemeLabel.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"

@interface BaseViewController ()
{
    
    UIView *_tipView;
    MBProgressHUD *_hud;
    UIWindow *_tipWindow;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
//    [self _loadImage];
//    [self setNavItem];
    // Do any additional setup after loading the view.
}

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        NSLog(@"init");
//    }
//    return self;
//    
//}
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        NSLog(@"initWithCoder");
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeDidChangeNotificationName object:nil];
//        
//    }
//    return self;
//    
//}

//- (void)themeDidChange:(NSNotification *)notification{
//    [self _loadImage];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航栏左右按钮
- (void)setNavItem{
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
//    
//    ThemeButton *leftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
//    leftButton.normalImageName = @"group_btn_all_on_title.png";
//    [leftButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    ThemeImageView *leftImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//    leftImageView.imageName = @"button_title.png";
//    
//    ThemeLabel *leftLable = [[ThemeLabel alloc] initWithFrame:CGRectMake(55, 0, 45, 50)];
//    leftLable.colorName = @"More_Item_Text_color";
//    leftLable.text = @"设置";
//    
//    
//    [leftImageView addSubview:leftLable];
//    [leftImageView addSubview:leftButton];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftImageView];
//    
//    
//    
//    ThemeButton *rightButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    rightButton.normalImageName = @"button_icon_plus.png";
//    [rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    ThemeImageView *rightImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    rightImageView.imageName = @"button_m.png";
//    
//    [rightImageView addSubview:rightButton];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightImageView];
    
//    ThemeButton *rightButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    
    
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc] initWithImage:<#(UIImage *)#> landscapeImagePhone:<#(UIImage *)#> style:<#(UIBarButtonItemStyle)#> target:<#(id)#> action:<#(SEL)#>
    //UIBarButtonItem *item = [UIBarButtonItem alloc] initWithCustomView:<#(UIView *)#>
    
}
- (void)setAction{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)editAction{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)showLoading:(BOOL)show {
    
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2 - 30, kScreenWidth, 20)];
        _tipView.backgroundColor = [UIColor clearColor];
        
        //activity
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.tag = 100;
        [_tipView addSubview:activityView];
        
        //label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"正在加载。。。";
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        [_tipView addSubview:label];
        
        label.left = (kScreenWidth - label.width) / 2;
        activityView.right = label.left - 5;
        
    }
    if (show) {
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_tipView viewWithTag:100];
        [activityView startAnimating];
        [self.view addSubview:_tipView];
    }else{
        if (_tipView.superview) {
            UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_tipView viewWithTag:100];
            [activityView stopAnimating];
            [_tipView removeFromSuperview];
        }
    }
    
}

- (void)showHUD:(NSString *)title {
    
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    }
    [_hud show:YES];
    _hud.labelText = title;
    _hud.dimBackground = YES;
    
}

- (void)hideHUD{
    [_hud hide:YES];
}

- (void)completeHUD:(NSString *)title {
    
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    //持续1.5隐藏
    [_hud hide:YES afterDelay:1.5];

    
}

#pragma -mark 设置背景图片
- (void)setBgImage{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadImage) name:kThemeDidChangeNotificationName object:nil];
    
    [self _loadImage];
}

- (void)_loadImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *img = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
}



#pragma  mark - 状态栏提示
- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
            operation:(AFHTTPRequestOperation *)operation{
    
    if (_tipWindow == nil) {
        //01 创建window
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        //02 显示文字 label
        UILabel *tpLabel = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        tpLabel.backgroundColor = [UIColor clearColor];
        tpLabel.textAlignment = NSTextAlignmentCenter;
        tpLabel.font = [UIFont systemFontOfSize:13];
        tpLabel.textColor = [UIColor whiteColor];
        tpLabel.tag = 100;
        [_tipWindow addSubview:tpLabel];
        
        
        //03 进度条
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(0, 20-3, kScreenWidth, 5);
        progressView.tag = 101;
        progressView.progress = 0.0;
        [_tipWindow addSubview:progressView];
    }
    
    UILabel *tpLabel = (UILabel*)[_tipWindow viewWithTag:100];
    tpLabel.text = title;
    
    
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];
    
    
    if (show) {
        _tipWindow.hidden = NO;
        
        if (operation != nil) {
            progressView.hidden = NO;
            [progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
        }else{
            progressView.hidden = YES;
        }
        
    }else{
        
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1];
    }
    
}

//
//- (void)hideTipWindow{
//    
//    [_tipWindow setHidden:YES];
//    
//    _tipWindow = nil;
//    
//}

- (void)removeTipWindow{
    _tipWindow.hidden = YES;
    _tipWindow = nil;
    
}


@end
