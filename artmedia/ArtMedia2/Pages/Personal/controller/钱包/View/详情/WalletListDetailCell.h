//
//  WalletListDetailCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WalletListBaseModel;
NS_ASSUME_NONNULL_BEGIN
@protocol WalletListDetailCellDelegate <NSObject>

@optional
- (void)didClickToDetailBtn:(id)sender;

@end

@interface WalletListDetailCell : UITableViewCell

@property (nonatomic ,weak) id <WalletListDetailCellDelegate> delegate;

@property (nonatomic ,assign) BOOL showDetailHidden;
@property (nonatomic ,copy ,nullable) NSString *titleText;

@property (nonatomic ,strong) WalletListBaseModel *detailModel;

@end

NS_ASSUME_NONNULL_END
