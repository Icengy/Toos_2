//
//  AMNewArtistMainTimeLineCell.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMNewArtistTimeLineModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AMNewArtistMainTimeLineCell : UITableViewCell

@property (nonatomic , strong) AMNewArtistTimeLineModel *model;

/// 控制竖线是否显示 -1:第一个cell，隐藏topLine 1:最后一个cell，隐藏bottomLine， 0:不隐藏，-2:全隐藏
@property (nonatomic , assign) NSInteger linePosition;

@end

NS_ASSUME_NONNULL_END
