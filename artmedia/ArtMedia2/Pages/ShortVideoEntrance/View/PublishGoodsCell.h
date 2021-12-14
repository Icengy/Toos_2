//
//  PublishGoodsCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoGoodsModel;
@class PublishGoodsCell;
@class VideoGoodsImageModel;
NS_ASSUME_NONNULL_BEGIN

@protocol PublishGoodsCellDelegate <NSObject>

@optional
/// reloaload
/// @param cell cell
/// @param sender sender
- (void)goodsCell:(PublishGoodsCell *)cell reloaload:(id _Nullable)sender;

/// 选择商品图片
/// @param cell cell
/// @param sender sender
- (void)goodsCell:(PublishGoodsCell *)cell pickGoodsIV:(id _Nullable)sender;

/// 删除商品图片
/// @param cell cell
/// @param imageIndex 图片序号
- (void)goodsCell:(PublishGoodsCell *)cell deleteGoodsIV:(NSInteger)imageIndex;

/// 记录用户输入内容
/// @param cell cell
/// @param inputStr 用户输入的内容
/// @param styleIndex //0：商品名称、1：商品介绍
- (void)goodsCell:(PublishGoodsCell *)cell userInputResultWithinputStr:(NSString *_Nullable)inputStr index:(NSInteger)styleIndex;

/// 选择商品分类
/// @param cell cell
/// @param goodsModel 商品分类二级model
- (void)goodsCell:(PublishGoodsCell *)cell selectGoodsClass:(VideoGoodsModel *_Nullable)goodsModel;

/// 选择商品创作日期
/// @param cell cell
/// @param goodsModel 商品分类二级model
- (void)goodsCell:(PublishGoodsCell *)cell selectGoodsCreateDate:(VideoGoodsModel *_Nullable)goodsModel;

///// 选择是否包邮
///// @param cell cell
///// @param isMail 是否包邮
//- (void)goodsCell:(PublishGoodsCell *)cell selecIstMail:(BOOL)isMail;

@end

@interface PublishGoodsCell : UITableViewCell

@property (weak, nonatomic) id <PublishGoodsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet AMTextField *goodsNameTF;
@property (weak, nonatomic) IBOutlet AMTextView *goodsIntroTV;
@property (weak, nonatomic) IBOutlet AMTextField *goodsDateTF;
@property (weak, nonatomic) IBOutlet AMTextField *goodsClassTF;
//@property (weak, nonatomic) IBOutlet AMButton *mailBtn;

@property (nonatomic ,strong) VideoGoodsModel *goodsModel;

- (void)reloadCollectView:(NSArray <VideoGoodsImageModel *>*)imagesData;

@end

NS_ASSUME_NONNULL_END
