//
//  FaceView.m
//  微微博
//
//  Created by cdf on 15/10/23.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "FaceView.h"

#define item_width  (kScreenWidth/7.0)  //单个表情占用的区域宽度
#define item_height 45   //单个表情占用的区域高度

#define face_height 30   //表情图片的宽度
#define face_width 30   //表情图片的高度

@implementation FaceView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self _initData];
    }
    return self;
    
    
}
- (NSInteger)pageNumber {
    
    return _items.count;
    
}
- (void)_initData {
    
    _items = [[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    NSInteger pageCount = 28;
    
    NSInteger page = emoticons.count/28;
    
    for (int i = 0 ; i <= page; i++) {
        NSInteger sub = emoticons.count - i * 28;
        if (sub < pageCount) {
            pageCount = sub;
        }
        NSRange range = NSMakeRange(pageCount * i, pageCount);
        
        NSArray *item2D = [emoticons subarrayWithRange:range];
        [_items addObject:item2D];
    }
    
    //计算当前视图的宽度和高度
    CGRect frame = self.frame;
    frame.size.width = _items.count * kScreenWidth;
    frame.size.height = item_height * 4;
    self.frame = frame;
    
    
    //创建放大镜视图
    _magnifierView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    _magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    _magnifierView.backgroundColor = [UIColor clearColor];
    _magnifierView.hidden = YES;
    [self addSubview:_magnifierView];
    
}

//绘制表情
- (void)drawRect:(CGRect)rect {
    
    int row = 0, colum = 0;
    for (int i = 0; i < _items.count; i ++) {
        NSArray *item2D = _items[i];
        for (int j = 0; j < item2D.count; j ++) {
            NSDictionary *item = item2D[j];
            //设置表情名
            NSString *imageName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            /**
             2.计算表情的坐标
             通过colum计算出x坐标：colum ---> x
             通过row计算出Y坐标：row --> y
             */
            CGFloat x = colum * item_width + (item_width - face_width)/2 + i * kScreenWidth;
            CGFloat y = row * item_height + (item_height - face_height)/2;
            
            CGRect imageFrame = CGRectMake(x, y, item_width, item_height);
            
            [image drawInRect:imageFrame];
            
            //更新行与列
            colum++;
            if (colum % 7 == 0) {
                colum = 0;
                row++;
            }
            if (row == 4) {
                row = 0;
            }
        }
    }
    
    
    
}

- (void)touchFace:(CGPoint)point {
    
    //计算页数
    NSInteger page = point.x / kScreenWidth;
    if (page >= _items.count) {
        return;
    }
    //计算colum,row
    NSInteger colum = (point.x - ((item_width - face_width)/2 + page * kScreenWidth))/item_width;
    NSInteger row = (point.y - (item_height - face_width)/2)/item_height;
    
    //范围处理
    /**
     row:0-3
     colum : 0-6
     */
    if (colum > 6) colum = 6;
    if (colum < 0) colum = 0;
    if (row > 3) row = 3;
    if (row < 0) row = 0;
    
    NSInteger index = row * 7 + colum;
    NSArray *item2D = [_items objectAtIndex:page];
    if (index >= item2D.count) {
        return;
    }
    //获取表情
    NSDictionary *item = [item2D objectAtIndex:index];
    NSString *imageName = [item objectForKey:@"png"];
    NSString *faceName = [item objectForKey:@"chs"];
    //放大镜中显示选中的表情
    //计算表情的中心坐标
    if (![_selectedFaceName isEqualToString:faceName]) {
        
        CGFloat x = colum * item_width + item_width/2 + page *kScreenWidth;
        CGFloat y = row * item_height + item_height/2;
        
        _magnifierView.center = CGPointMake(x, 0);
        _magnifierView.bottom = y;
        
        UIImageView *faceImageView = (UIImageView *)[_magnifierView viewWithTag:100];
        faceImageView.image = [UIImage imageNamed:imageName];
        
        _selectedFaceName = faceName;
        
        
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _magnifierView.hidden = NO;
    
    //禁止滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollerView = (UIScrollView *)self.superview;
        scrollerView.scrollEnabled = NO;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _magnifierView.hidden = YES;
    //开启滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        scrollView.scrollEnabled = YES;
        
    }
    //通知代理
    if ([self.delegate respondsToSelector:@selector(faceDidSelect:)]) {
        [self.delegate faceDidSelect:_selectedFaceName];
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
    
}



@end
