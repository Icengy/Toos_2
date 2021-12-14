//
//  RecommendArtsCollectionCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoArtModel;
NS_ASSUME_NONNULL_BEGIN

@interface RecommendArtsCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) VideoArtModel *artModel;

@end

NS_ASSUME_NONNULL_END
