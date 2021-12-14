//
//  GoodsImagesCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoGoodsImageModel;
NS_ASSUME_NONNULL_BEGIN

@interface GoodsImagesCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet AMButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsIV;
@property (weak, nonatomic) IBOutlet AMButton *deleteBtn;

@property (nonatomic ,strong) NSIndexPath *indexPath;
@property (nonatomic ,strong) VideoGoodsImageModel *currentImage;

@property (nonatomic ,copy) void(^ clickGoodsPickBlock)(void);
@property (nonatomic ,copy) void(^ clickGoodsDeleteBlock)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
