//
//  SearchResultListViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/12/16.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultListViewController : BaseViewController

@property (nonatomic ,assign) SearchResultType resultType;
@property (nonatomic ,copy) NSString *keyword;

@end

NS_ASSUME_NONNULL_END
