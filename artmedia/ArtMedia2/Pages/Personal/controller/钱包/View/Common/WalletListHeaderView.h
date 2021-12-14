//
//  WalletListHeaderView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/11.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletListHeaderView : UIView
@property (nonatomic ,assign) AMWalletItemStyle style;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSArray *dataArray;
@property(nonatomic,copy) void(^clickIndexBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
