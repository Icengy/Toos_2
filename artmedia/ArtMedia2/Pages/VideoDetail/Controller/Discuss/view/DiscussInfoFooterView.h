//
//  DiscussInfoFooterView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussItemInfoModel;
@class DiscussInfoFooterView;
NS_ASSUME_NONNULL_BEGIN

@protocol DiscussInfoFooterDelegate <NSObject>

@optional
- (void)infoFooter:(DiscussInfoFooterView *)infoCell didSelectedMore:(id)sender withModel:(DiscussItemInfoModel *)model;

@end

@interface DiscussInfoFooterView : UIView

@property (nonatomic ,strong) DiscussItemInfoModel *model;
@property (weak, nonatomic) id <DiscussInfoFooterDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
