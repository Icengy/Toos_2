//
//  PersonalWalletTableViewCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPersonalModel;
@class PersonalWalletTableViewCell;
NS_ASSUME_NONNULL_BEGIN

@protocol PersonalWalletItemDelegate <NSObject>

@required
- (void)walletCell:(PersonalWalletTableViewCell *)walletCell didSelectedWalletItemWithIndex:(NSInteger)index;
- (void)walletCell:(PersonalWalletTableViewCell *)walletCell didSelectedToAccount:(id)sender;

@end

@interface PersonalWalletTableViewCell : UITableViewCell

@property (weak ,nonatomic) id <PersonalWalletItemDelegate> delegate;
@property (nonatomic ,strong) CustomPersonalModel *model;

@end

NS_ASSUME_NONNULL_END
