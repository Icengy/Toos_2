//
//  GoodsEditView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BasePopView.h"

@class GoodsEditView;
@class VideoGoodsModel;
NS_ASSUME_NONNULL_BEGIN

@protocol GoodsEditViewDelegate <NSObject>

@optional
/// 是否售卖作品
/// @param editView editView
/// @param isSell YES:可销售 NO:非卖品
- (void)editView:(GoodsEditView *)editView selecIstToSell:(BOOL)isSell;

/// 记录用户输入的价格
/// @param editView editView
/// @param inputStr 用户输入的内容
- (void)editView:(GoodsEditView *)editView userInputResultForPriceWithinputStr:(NSString *_Nullable)inputStr;

/// 选择是否包邮
/// @param editView editView
/// @param isMail 是否包邮
- (void)editView:(GoodsEditView *)editView selecIstMail:(BOOL)isMail;

/// 删除作品
/// @param editView editView
/// @param sender sender
- (void)editView:(GoodsEditView *)editView selecIstToDelete:(id)sender;

/// 确认修改
/// @param editView editView
/// @param sender sender
- (void)editView:(GoodsEditView *)editView selecIstToConfirm:(id)sender;

@end

@interface GoodsEditView : BasePopView

@property (weak, nonatomic) id <GoodsEditViewDelegate> delegate;
@property (strong, nonatomic) VideoGoodsModel *model;

@end

NS_ASSUME_NONNULL_END
