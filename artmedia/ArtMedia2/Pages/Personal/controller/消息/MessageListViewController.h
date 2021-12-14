//
//  MessageListViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/5/25.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 我收到的赞列表页面
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class MessageListViewController;
@protocol MessageListViewControllerDelegate <NSObject>

@optional
- (void)messagelistVC:(MessageListViewController *)messageVC updateUnreadCount:(NSDictionary *)unreadInfo;

@end

@interface MessageListViewController : BaseViewController
@property (nonatomic ,weak) id <MessageListViewControllerDelegate> delegate;
@property (nonatomic ,assign) MessageDetailListStyle listStyle;

@end

NS_ASSUME_NONNULL_END
