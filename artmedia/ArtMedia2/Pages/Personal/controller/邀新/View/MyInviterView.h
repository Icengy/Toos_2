//
//  MyInviterView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BasePopView.h"

@class InviteInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MyInviterView : BasePopView

@property (nonatomic ,copy) void(^ confirmBlock)(NSString *_Nullable inviteCode);

@property (nonatomic ,strong ,nullable) InviteInfoModel *inviterModel;

@end

NS_ASSUME_NONNULL_END
