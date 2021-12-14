//
//  AMNewArtistMainHeadView.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMNewArtistMainHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *headLabel;

@property (weak, nonatomic) IBOutlet UIStackView *stackBackView;
@property (weak, nonatomic) IBOutlet UILabel *meetNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet AMButton *moreVideoButton;
@property (weak, nonatomic) IBOutlet AMButton *moreInfoButton;

@property (nonatomic , copy) void(^moreVideoClickBlock)(void);
@property (nonatomic , copy) void(^moreInfoClickBlock)(void);
+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
