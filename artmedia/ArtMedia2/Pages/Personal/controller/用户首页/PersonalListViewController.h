//
//  PersonalListViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/17.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseItemViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalListViewController : BaseItemViewController

///列表样式
@property (assign, nonatomic) PersonalControllerListType listType;

@property (nonatomic ,copy) NSString *userID;

@end

NS_ASSUME_NONNULL_END
