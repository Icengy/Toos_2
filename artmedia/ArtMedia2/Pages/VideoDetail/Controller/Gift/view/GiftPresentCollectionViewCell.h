//
//  GiftPresentCollectionViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/12/7.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftPresentCollectionViewCell : UICollectionViewCell

@property (nonatomic ,assign) BOOL isSelected;
@property (nonatomic ,strong) NSIndexPath *indexPath;
@property(nonatomic,copy) void(^cellSelectedBlock)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
