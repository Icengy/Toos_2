//
//  GoodsClassViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

#import "GoodsClassTableCell.h"

@class GoodsClassModel;
NS_ASSUME_NONNULL_BEGIN

@protocol GoodsClassDelegate <NSObject>

@optional
- (void)viewController:(BaseViewController *)viewController didSelectedGoodsClass:(GoodsClassModel *)classModel;

@end

@interface GoodsClassViewController : BaseViewController

@property (weak, nonatomic) id <GoodsClassDelegate> delegate;
@property (nonatomic ,strong) GoodsClassModel *classModel;

@end

NS_ASSUME_NONNULL_END
