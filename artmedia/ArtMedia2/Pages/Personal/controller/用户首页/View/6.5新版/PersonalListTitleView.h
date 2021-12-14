//
//  PersonalListTitleView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalListTitleView : UIView

@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *badges;
@property(nonatomic,copy) void(^clickIndexBlock)(NSInteger index);
@property (nonatomic ,assign) UIEdgeInsets insets;

@end

NS_ASSUME_NONNULL_END
