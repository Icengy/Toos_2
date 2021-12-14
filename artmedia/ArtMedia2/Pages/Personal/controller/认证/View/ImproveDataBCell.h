//
//  ImproveDataBCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ImproveImageButton;
@class IdentifyModel;

@class ImproveDataBCell;
@protocol ImproveDataBCellDelegate <NSObject>

@optional;
- (void)cell:(ImproveDataBCell *)cell willDisplayCell:(CGFloat)contentSizeHeight;
- (void)cell:(ImproveDataBCell *)cell didSelectedToPickImages:(id _Nullable)sender;
- (void)cell:(ImproveDataBCell *)cell didSelectedToDeleteImage:(NSInteger)index;

@end

@interface ImproveDataBCell : UITableViewCell <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) id <ImproveDataBCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong) IdentifyModel *model;

@property(nonatomic,copy) void(^editImageBlock)(NSInteger tag);
@property(nonatomic,copy) void(^editDataBlock)(NSString *input);
@property(nonatomic,copy) void(^afterDeleteImageBlock)(IdentifyModel *model);

@end

NS_ASSUME_NONNULL_END
