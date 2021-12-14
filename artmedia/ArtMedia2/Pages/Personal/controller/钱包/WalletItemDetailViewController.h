//
//  WalletItemDetailViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 详情页
//

#import "BaseViewController.h"

@class WalletListBaseModel;
NS_ASSUME_NONNULL_BEGIN

@interface WalletItemDetailViewController : BaseViewController

@property (nonatomic ,strong) WalletListBaseModel *detailModel;

@end

NS_ASSUME_NONNULL_END
