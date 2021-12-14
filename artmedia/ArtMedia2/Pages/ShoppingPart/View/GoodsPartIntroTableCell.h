//
//  GoodsPartIntroTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoGoodsModel;
NS_ASSUME_NONNULL_BEGIN

@interface GoodsPartIntroTableCell : UITableViewCell

@property (nonatomic ,strong) VideoGoodsModel *model;
@property (strong, nonatomic) NSDictionary *categoryData;

@end

NS_ASSUME_NONNULL_END
