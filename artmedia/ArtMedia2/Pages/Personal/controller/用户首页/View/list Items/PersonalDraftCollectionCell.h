//
//  PersonalDraftCollectionCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/17.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;

NS_ASSUME_NONNULL_BEGIN

@interface PersonalDraftCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *videoCoverIV;

@property (weak, nonatomic) IBOutlet AMButton *lastEditTimeLabel;

@property (nonatomic ,strong) VideoListModel *model;

@end

NS_ASSUME_NONNULL_END
