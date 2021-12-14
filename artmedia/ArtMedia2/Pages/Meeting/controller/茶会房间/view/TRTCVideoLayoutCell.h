//
//  TRTCVideoLayoutCell.h
//  LiveStream
//
//  Created by icnengy on 2020/4/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMTRTCVideoView;

NS_ASSUME_NONNULL_BEGIN

@interface TRTCVideoLayoutCell : UICollectionViewCell
@property (strong, nonatomic) AMTRTCVideoView *mainView;
@end

NS_ASSUME_NONNULL_END
