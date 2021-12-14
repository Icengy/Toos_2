//
//  MineMeetingItemView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineMeetingItemView : UIView

@property(nonatomic,strong) IBOutlet UIView* view;

@property (nonatomic ,copy) void(^ ItemClickBlock)(void);

@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;

@end

NS_ASSUME_NONNULL_END
