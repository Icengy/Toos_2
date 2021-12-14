//
//  InviteNewViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

@class InviteInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface InviteNewViewController : BaseViewController
/// 是否为二级页面
@property (nonatomic ,assign) BOOL isSecondary;
/// 仅当isSecondary = YES时 hostModel有值
@property (nonatomic ,strong) InviteInfoModel *hostModel;
@end

NS_ASSUME_NONNULL_END
