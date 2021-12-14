//
//  BankCardListViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/24.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

#import "BankCardListTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BankCardListDelegate <NSObject>

@optional
- (void)viewController:(BaseViewController *)viewController didSelectedArtField:(BankCardListModel *_Nullable)bankModel;
@end

@interface BankCardListViewController : BaseViewController

@property (nonatomic ,weak) id <BankCardListDelegate> delegate;

@property (nonatomic, strong) BankCardListModel *selectedModel;

@end

NS_ASSUME_NONNULL_END
