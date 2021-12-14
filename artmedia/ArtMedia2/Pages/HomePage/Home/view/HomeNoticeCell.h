//
//  HomeNoticeCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/30.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <GYNoticeViewCell.h>

@class HomeInforModel;
NS_ASSUME_NONNULL_BEGIN

@interface HomeNoticeCell : GYNoticeViewCell

@property (nonatomic ,strong) HomeInforModel *noticeModel;

@end

NS_ASSUME_NONNULL_END
