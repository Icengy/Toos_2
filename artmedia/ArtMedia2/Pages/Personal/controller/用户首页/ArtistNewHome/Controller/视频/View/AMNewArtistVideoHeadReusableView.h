//
//  AMNewArtistVideoHeadReusableView.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMNewArtistVideoHeadReusableView : UICollectionReusableView
@property (nonatomic , copy) void(^buttonClickBlock)(NSInteger tag);
@property (nonatomic , copy) NSString *count_num;
@end

NS_ASSUME_NONNULL_END
