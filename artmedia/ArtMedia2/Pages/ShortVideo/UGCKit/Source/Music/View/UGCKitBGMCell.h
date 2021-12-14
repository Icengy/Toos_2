// Copyright (c) 2019 Tencent. All rights reserved.

#import <UIKit/UIKit.h>
#import "UGCKitCircleProgressView.h"

#import "MCDownloadManager.h"
#import "UGCKitMem.h"

@class UGCKitBGMCell;

@protocol UGCKitBGMCellDelegate <NSObject>
- (void)onBGMDownLoad:(UGCKitBGMCell *)cell;
@end

@interface UGCKitBGMCell : UITableViewCell

@property (weak, nonatomic) id <UGCKitBGMCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) UIView *progressView;

/// 未下载
@property (strong, nonatomic) NSString *downloadText;
/// 下载中
@property (strong, nonatomic) NSString *downloadingText;
/// 已下载未使用
@property (strong, nonatomic) NSString *applyText;
/// 已下载使用中
@property (strong, nonatomic) NSString *applyingText;
/// 下载地址
@property (strong, nonatomic) NSString *downloadUrlStr;

@property (strong, nonatomic) UIImage *downloadButtonBackground;
@property (strong, nonatomic) UIImage *progressButtonBackground;

- (void) setDownloadProgress:(CGFloat)progress;

@end
