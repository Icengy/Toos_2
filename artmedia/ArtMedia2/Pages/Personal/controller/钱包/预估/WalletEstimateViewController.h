//
//  WalletEstimateViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//
// 预估销售/预估收益主界面
//

#import "BaseItemParentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletEstimateViewController : BaseItemParentViewController

@property (nonatomic ,assign) AMWalletItemStyle style;
@property (nonatomic ,copy) NSString *estimateMoney;

@end

NS_ASSUME_NONNULL_END
