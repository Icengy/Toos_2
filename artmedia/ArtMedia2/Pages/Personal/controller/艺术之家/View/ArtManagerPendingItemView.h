//
//  ArtManagerPendingItemView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/4.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtManagerPendingItemView : UIView

@property (nonatomic ,weak) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *counttitleLabel;

@property (nonatomic ,copy) void(^ selectedItemBlock)(ArtManagerPendingItemView *item);

@end

NS_ASSUME_NONNULL_END
