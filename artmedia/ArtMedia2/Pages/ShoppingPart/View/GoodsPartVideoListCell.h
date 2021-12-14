//
//  GoodsPartVideoListCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsPartVideoListCell;
NS_ASSUME_NONNULL_BEGIN

@protocol GoodsPartVideoListCellDelegate <NSObject>

@optional
- (void)listCell:(GoodsPartVideoListCell *)cell didSelectVideoItem:(NSInteger )index;
- (void)listCell:(GoodsPartVideoListCell *)cell didReloadData:(id)sender;

@end

@interface GoodsPartVideoListCell : UITableViewCell

@property (nonatomic ,weak) id <GoodsPartVideoListCellDelegate >delegate;
@property (nonatomic ,strong) NSArray *videoArray;

@end

NS_ASSUME_NONNULL_END
