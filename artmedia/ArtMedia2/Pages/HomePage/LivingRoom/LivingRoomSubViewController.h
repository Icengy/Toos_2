//
//  LivingRoomSubViewController.h
//  ArtMedia2
//
//  Created by 名课 on 2020/9/1.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface LivingRoomSubViewController : BaseViewController

/// 页面类型，将来可能会用来传入接口，获取不同的数据
@property (copy , nonatomic) NSString *utype;

@end

NS_ASSUME_NONNULL_END
