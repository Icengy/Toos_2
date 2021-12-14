//
//  SearchResultVideoCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SearchResultVideoCell : UITableViewCell

@property (nonatomic ,strong) VideoListModel *model;

@end

NS_ASSUME_NONNULL_END
