//
//  PublishVideoCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoColumnModel;
@class PublishVideoCell;
NS_ASSUME_NONNULL_BEGIN

@protocol PublishVideoCellDelegate <NSObject>

@optional
/// 视频简介输入
- (void) videoCell:(PublishVideoCell *)videoCell introTextChanged:(NSString *)introText;
/// 视频频道选择
- (void) videoCell:(PublishVideoCell *)videoCell columnChanged:(VideoColumnModel *)selectedColumn;
/// 重加载频道
- (void) videoCell:(PublishVideoCell *)videoCell reloadWithColumn:(id)sender;
/// 编辑视频封面
- (void) videoCell:(PublishVideoCell *)videoCell editVideoCover:(id)sender;

@end

@interface PublishVideoCell : UITableViewCell

@property (weak, nonatomic) id <PublishVideoCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *videoCutIV;
@property (weak, nonatomic) IBOutlet AMTextView *videoIntroView;

@property (nonatomic ,copy) void(^ introTextChangeBlock)(NSString *_Nullable introText);
@property (nonatomic ,copy) void(^ columnChangeBlock)(VideoColumnModel *_Nullable selectedColumn);
@property (nonatomic ,copy) void(^ reloadColumnBlock)(void);
@property (nonatomic ,copy) void(^ editVideoCoverBlock)(void);


- (void)setPublishVideoCellWithImage:(id _Nullable)cutImageUrl videoIntro:(NSString *_Nullable)videoIntro;
- (void)updateColumn:(NSArray <VideoColumnModel *>*_Nullable)columnArray withSelectColumn:(VideoColumnModel *_Nullable)selectColumn;

@end

NS_ASSUME_NONNULL_END
