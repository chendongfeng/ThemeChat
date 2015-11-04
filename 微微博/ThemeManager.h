//
//  ThemeManager.h
//  微微博
//
//  Created by cdf on 15/10/12.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

@property (nonatomic,copy)NSString *themeName;//主题名字
@property (nonatomic,strong)NSDictionary *themeConfig;//theme.plist的内容
@property (nonatomic,strong)NSDictionary *colorConfig;//颜色

+ (ThemeManager *)shareInstance;//单例类方法，获得唯一对象

- (UIImage *)getThemeImage:(NSString *)imageName;//根据图片名字获得对应主题包下的图片
- (UIColor *)getThemeColor:(NSString *)colorName;

@end
