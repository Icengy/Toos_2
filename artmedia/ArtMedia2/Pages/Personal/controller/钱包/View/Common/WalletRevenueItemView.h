//
//  WalletRevenueItemView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WalletRevenueItemViewDelegate <NSObject>
@optional
- (void)didClickToCashout:(id)sender;

@end

@interface WalletRevenueItemView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic, weak) id <WalletRevenueItemViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet AMButton *cashoutBtn;

@end

NS_ASSUME_NONNULL_END
