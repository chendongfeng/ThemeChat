//
//  UIView+ViewController.m
//  微微博
//
//  Created by cdf on 15/10/17.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController{
    
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
        
    }while (next != nil);
    
    return nil;
    
}

@end
