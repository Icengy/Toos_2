//
//  AMMeetingListHeader.h
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMMeetingListHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (AMMeetingListHeader *)shareInstance;

@end

NS_ASSUME_NONNULL_END
