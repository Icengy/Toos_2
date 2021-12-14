//
//  OrderGoodsIntroCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/7.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoGoodsModel;
@class MyOrderModel;
NS_ASSUME_NONNULL_BEGIN

@interface OrderGoodsIntroCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AMButton *refundBtn;

@property (nonatomic ,strong) VideoGoodsModel *goodsModel;
@property (nonatomic ,strong) MyOrderModel *orderModel;

@property(nonatomic,copy) void(^clickToRefundBlock)(void);

@end

NS_ASSUME_NONNULL_END
