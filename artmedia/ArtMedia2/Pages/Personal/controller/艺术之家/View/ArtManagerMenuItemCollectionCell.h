//
//  ArtManagerMenuItemCollectionCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtManagerMenuItemCollectionCell : UICollectionViewCell

@property (nonatomic ,copy) NSString *imageStr;
@property (nonatomic ,copy) NSString *titleStr;

@property (nonatomic ,copy) void(^ selectedItemBlock)(id sender);

@end

NS_ASSUME_NONNULL_END
