//
//  SendViewController.m
//  微微博
//
//  Created by cdf on 15/10/19.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#import "MMDrawerController.h"
#import "DataService.h"


@interface SendViewController ()

@end

@implementation SendViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _cteateNavItem];
    [self _createEditorViews];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //导航栏不透明，当导航栏不透明的时候 ，子视图的y的0位置在导航栏下面
    self.navigationController.navigationBar.translucent = NO;
    _textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    
    //设置textView 内容偏移
//    _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //弹出键盘
    [_textView becomeFirstResponder];
    
}



#pragma mark - 创建子视图

- (void)_cteateNavItem{
    
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.normalImageName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendButton.normalImageName = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
    
    
}

- (void)closeAction {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window.rootViewController isKindOfClass:[MMDrawerController class]]) {
        MMDrawerController *mmDrawer = (MMDrawerController *)window.rootViewController;
        [mmDrawer closeDrawerAnimated:YES completion:NULL];
        
    }
    [_textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)sendAction {
    
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
    }else if (text.length > 140) {
        error = @"微博内容大于140个字符";
    }
    if (error != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    AFHTTPRequestOperation *operation = [DataService sendWeibo:text image:_sendImage block:^(id result) {
        NSLog(@"发送反馈 %@",result);
        [self showStatusTip:@"发送完毕" show:NO operation:nil];
    }];
    
    [self showStatusTip:@"正在发送" show:YES operation:operation];
    [self closeAction];
    
}

- (void)_createEditorViews{
    
    //1 文本输入视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = YES;
    
    _textView.backgroundColor = [UIColor lightGrayColor];
    //圆角边框
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_textView];
    
    //2 编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    //3.创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        button.normalImageName = imgName;
        [_editorBar addSubview:button];
    }
    //3 创建label 显示位置信息
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _locationLabel.hidden = YES;
    _locationLabel.font = [UIFont systemFontOfSize:14];
    _locationLabel.backgroundColor = [UIColor grayColor];
    [_editorBar addSubview:_locationLabel];

}

- (void)buttonAction:(UIButton *)button {
    
    if (button.tag == 10) {
        [self _selectPhoto];
    }else if (button.tag == 13) {
        [self _location];
    }else if (button.tag == 14) {
        
        BOOL isFirstResponder = _textView.isFirstResponder;
        //输入框是否是第一响应者，如果是，说明键盘已经显示
        if (isFirstResponder) {
            [_textView resignFirstResponder];
            [self _showFaceView];
        }else {
            [self _hideFaceView];
            
            [_textView becomeFirstResponder];
        }
    }
    
}
#pragma mark - 键盘弹出通知

- (void)keyBoardWillShow:(NSNotification *)notification {

    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect frame = [bounsValue CGRectValue];
    //2 键盘高度
    CGFloat height = frame.size.height;
    //3 调整视图的高度
    _editorBar.bottom = kScreenHeight - height- 64;

}

#pragma mark - 表情处理
- (void)_showFaceView {
    
    if (_faceViewPanel == nil) {
        
        _faceViewPanel = [[FaceScrollView alloc] init];
        [_faceViewPanel setFaceViewDelegate:self];
        _faceViewPanel.top = kScreenHeight - 64;
        [self.view addSubview:_faceViewPanel];
        
    }
    //显示表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.bottom = kScreenHeight - 64;
        _editorBar.bottom = _faceViewPanel.top;
    }];
    
    
}
#pragma mark - 隐藏表情
- (void)_hideFaceView {
    
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.top = kScreenHeight - 64;
    }];
    
}


#pragma mark - 选择照片
- (void)_selectPhoto{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
    }else if (buttonIndex == 1){
        
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else {
        
        return;
        
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

//照片选择代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //弹出相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    //2 取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //3 显示缩略图
    
    if (_zoomImageView == nil) {
        
        _zoomImageView = [[ZoomImageView alloc] initWithImage:image];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom+10, 80, 80);
        [self.view addSubview:_zoomImageView];
        
        _zoomImageView.delegate = self;
        
    }
    _zoomImageView.image = image;
    _sendImage = image;
}

- (void)imageWillZoomOut:(ZoomImageView *)imageView {
    
    [_textView becomeFirstResponder];
    
}

- (void)imageWillZoomIn:(ZoomImageView *)imageView {
    
    [_textView resignFirstResponder];
    
}

- (void)_location {
    
    if (_locationManager != nil) {
        _locationManager = [[CLLocationManager alloc] init];
        //判断系统版本信息 ，如果大于8.0 则调用以下方法获取授权
        if (kVersion > 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [manager stopUpdatingLocation];
    //取得地理位置信息
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度 ：%lf,纬度： %lf",coordinate.longitude,coordinate.latitude);
    
    //地理位置反编码
    //一 新浪位置反编码 接口说明  http://open.weibo.com/wiki/2/location/geo/geo_to_address
    
    NSString *coordiateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:coordiateStr forKey:@"coordinate"];
    
    
    __weak SendViewController *weakSelf = self;
    [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *geos = [result objectForKey:@"geos"];
        if (geos.count > 0) {
            NSDictionary *geoDic = [geos lastObject];
            
            NSString *addr = [geoDic objectForKey:@"address"];
            NSLog(@"地址 %@",addr);
            
            
            __strong SendViewController *strongSelf = weakSelf;
            
            strongSelf->_locationLabel.hidden = NO;
            
            strongSelf->_locationLabel.text = addr;
        }
        
    }];
    
    //二 iOS内置 反编码
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *place = [placemarks lastObject];
        NSLog(@"%@",place.name);
        
        
    }];
    
}

- (void)faceDidSelect:(NSString *)text {
    
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,text];
    
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
