//
//  CommentCell.h
//  微微博
//
//  Created by cdf on 15/10/17.
//  Copyright (c) 2015年 cdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "WXLabel.h"


@interface CommentCell : UITableViewCell<WXLabelDelegate>

{
    WXLabel *_commentTextLabel;
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property(nonatomic,retain)CommentModel *commentModel;

//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel;


@end
