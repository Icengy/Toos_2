//
//  ImproveDataBImageCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImproveDataBImageCell : UICollectionViewCell

@property(nonatomic,copy,nullable) NSString *imageStr;
@property(nonatomic,copy) void(^deleteImageBlock)(void);

@end

NS_ASSUME_NONNULL_END
