//
//  MyShortVideoListTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
@class MyShortVideoListTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol MyShortVideoListTableCellDelegate <NSObject>

@required
/// 查看视频详情
- (void)shortVideoCell:(MyShortVideoListTableCell *)shortVideoCell didSelectedToDetail:(id)sender;

@optional
/// 删除
- (void)shortVideoCell:(MyShortVideoListTableCell *)shortVideoCell didSelectedToDelete:(id)sender;
/// 编辑
- (void)shortVideoCell:(MyShortVideoListTableCell *)shortVideoCell didSelectedToEdit:(id)sender;
/// 查看作品
- (void)shortVideoCell:(MyShortVideoListTableCell *)shortVideoCell didSelectedToLookworks:(id)sender;

@end

@interface MyShortVideoListTableCell : UITableViewCell

@property (nonatomic ,weak) id <MyShortVideoListTableCellDelegate> delegate;
@property (nonatomic ,strong) VideoListModel *model;

@end

NS_ASSUME_NONNULL_END
