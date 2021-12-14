//
//  HK_Label.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^HK_LabelBlock)(NSString *labeltext,NSInteger index);
@interface HK_Label : UILabel
@property (nonatomic,copy)HK_LabelBlock block;
@end

NS_ASSUME_NONNULL_END
