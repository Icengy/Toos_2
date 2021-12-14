//
//  AMMeetingSettingBView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMMeetingSettingBView;
NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingBondModel : NSObject

@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,assign) BOOL isDefault;
@property (nonatomic ,copy) NSString *teaPrice;

@end

@protocol AMMeetingSettingBViewDelegate <NSObject>

@required
- (void)settingBCell:(AMMeetingSettingBView *)cell didSelectedItem:(NSString *)selectedNum;
- (void)settingBCell:(AMMeetingSettingBView *)cell didLoadItemsToHeight:(CGFloat)height;

@end

@interface AMMeetingSettingBView : UIView

@property (nonatomic ,weak) id <AMMeetingSettingBViewDelegate> delegate;
@property (nonatomic ,strong) NSArray <AMMeetingBondModel *>*dataArray;
@property (nonatomic ,copy, nullable) NSString *priceStr;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
