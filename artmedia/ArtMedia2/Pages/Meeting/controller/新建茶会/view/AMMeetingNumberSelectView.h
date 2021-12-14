//
//  AMMeetingNumberSelectView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingNumberSelectView : UIView

+ (instancetype _Nullable)shareInstance;

@property (nonatomic ,strong) NSArray *selectedArray;
@property (nonatomic ,copy) void(^ numberChangedBlock)(NSArray *_Nullable numberArray);

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
