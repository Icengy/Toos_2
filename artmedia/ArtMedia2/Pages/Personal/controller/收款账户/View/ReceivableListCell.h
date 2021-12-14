//
//  ReceivableListCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/21.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReceivableModel;
@class ReceivableListCell;
NS_ASSUME_NONNULL_BEGIN

@protocol ReceivableListCellDelegate <NSObject>

@optional
/// 解除绑定
- (void)cell:(ReceivableListCell *)cell didClickToRemoveBind:(id)sender withModel:(ReceivableModel *_Nullable)model;

@end

@interface ReceivableListCell : UITableViewCell

@property (nonatomic ,weak) id <ReceivableListCellDelegate> delegate;
@property (nullable ,nonatomic ,strong) ReceivableModel *model;

@property (nonatomic ,assign) NSInteger receiveType;

@end

NS_ASSUME_NONNULL_END
