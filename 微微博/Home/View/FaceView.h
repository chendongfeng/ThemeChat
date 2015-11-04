//
//  FaceView.h
//  微微博
//
//  Created by cdf on 15/10/23.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>

- (void)faceDidSelect:(NSString *)text;

@end

@interface FaceView : UIView

{
    NSMutableArray *_items;
    UIImageView *_magnifierView;
    NSString *_selectedFaceName;
    
}


@property (nonatomic,readonly) NSInteger pageNumber;
@property (nonatomic,weak) id<FaceViewDelegate> delegate;



@end
