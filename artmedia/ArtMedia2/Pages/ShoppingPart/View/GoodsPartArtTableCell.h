//
//  GoodsPartArtTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsPartArtTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol GoodsPartArtCellDelegate <NSObject>

@optional
- (void)artCell:(GoodsPartArtTableCell *)artCell didSelectedToFollow:(AMButton *)sender;
- (void)artCell:(GoodsPartArtTableCell *)artCell didSelectedToShowArtHome:(id)sender;

@end

@interface GoodsPartArtTableCell : UITableViewCell

@property (nonatomic ,weak) id <GoodsPartArtCellDelegate> delegate;
@property (nonatomic ,strong) UserInfoModel *model;
//@property (nonatomic ,strong) NSDictionary *artInfo;

@end

NS_ASSUME_NONNULL_END
