//
//  DiscussReplyTableFooterView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussReplyTableFooterView;
NS_ASSUME_NONNULL_BEGIN

@protocol DiscussReplyTableFooterDelegate <NSObject>

@optional
- (void)footerView:(DiscussReplyTableFooterView *)footer didSelectedMore:(id)sender;

@end

@interface DiscussReplyTableFooterView : UIView

@property (nonatomic ,weak) id <DiscussReplyTableFooterDelegate> delegate;
@property (nonatomic ,assign) NSInteger moreCount;

@end

NS_ASSUME_NONNULL_END
