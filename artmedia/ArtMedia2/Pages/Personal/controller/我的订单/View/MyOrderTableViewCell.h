//
//  MyOrderTableViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@class MyOrderTableViewCell;
NS_ASSUME_NONNULL_BEGIN

@protocol MyOrderCellDelegate <NSObject>

@optional
- (void)orderCell:(MyOrderTableViewCell *)orderCell didClickToOpeation:(MyOrderModel *)orderModel;
- (void)orderCell:(MyOrderTableViewCell *)orderCell didClickToQueRenShouHuo:(MyOrderModel *)orderModel;

@end

@interface MyOrderTableViewCell : UITableViewCell

@property (nonatomic, weak) id <MyOrderCellDelegate> delegate;

@property (nonatomic ,strong) MyOrderModel *orderModel;

@property(nonatomic,copy) void(^clickToOpeationBlock)(MyOrderModel *orderModel);

- (void)updateOrderState:(NSString *_Nullable)orderState stateColor:(UIColor *_Nullable)stateColor orderOperation:(NSString *_Nullable)orderOperation operationColor:(UIColor *_Nullable)operationColor descText:(NSString *_Nullable)descText;

@end

NS_ASSUME_NONNULL_END
