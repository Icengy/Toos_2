//
//  PersonalWalletItemView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/5.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalWalletItemView : UIView

@property(nonatomic,weak) IBOutlet UIView* view;

@property (nonatomic ,copy) void(^ personalWalletItemBlock)(void);

@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;

@end

NS_ASSUME_NONNULL_END
