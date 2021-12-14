//
//  GoodsSellTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoGoodsModel;
@class GoodsSellTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol GoodsSellTableCellDelegate <NSObject>

@optional
/// 记录用户输入的价格
/// @param cell cell
/// @param inputStr 用户输入的内容
- (void)sellCell:(GoodsSellTableCell *)cell userInputResultForPriceWithinputStr:(NSString *_Nullable)inputStr;

/// 选择是否包邮
/// @param cell cell
/// @param isMail 是否包邮
- (void)sellCell:(GoodsSellTableCell *)cell selecIstMail:(BOOL)isMail;

@end

@interface GoodsSellTableCell : UITableViewCell

@property (weak, nonatomic) id <GoodsSellTableCellDelegate> delegate;

@property (nonatomic ,strong) VideoGoodsModel *goodsModel;

@end

NS_ASSUME_NONNULL_END
