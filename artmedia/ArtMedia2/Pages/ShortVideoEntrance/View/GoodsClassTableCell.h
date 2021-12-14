//
//  GoodsClassTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsClassTableCell : UITableViewCell

@property (nonatomic ,strong) GoodsClassModel *model;
@property (nonatomic ,assign) NSInteger style;

@end

NS_ASSUME_NONNULL_END
