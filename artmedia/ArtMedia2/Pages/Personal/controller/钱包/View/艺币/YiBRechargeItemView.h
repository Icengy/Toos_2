//
//  YiBRechargeItemView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YiBRechargeItemViewDelegate <NSObject>

@optional
- (void)rechargeItemWillDisplayCellWithContentSize:(CGSize)contentSize;
- (void)rechargeItemDidSelectedItemAtIndex:(NSInteger)index;

@end

@interface YiBRechargeItemView : UIView

@property (nonatomic ,weak) id <YiBRechargeItemViewDelegate> delegate;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
