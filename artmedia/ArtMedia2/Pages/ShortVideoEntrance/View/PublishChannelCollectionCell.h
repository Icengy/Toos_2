//
//  PublishChannelCollectionCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoColumnModel;
NS_ASSUME_NONNULL_BEGIN

@interface PublishChannelCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) VideoColumnModel *channel;

@end

NS_ASSUME_NONNULL_END
