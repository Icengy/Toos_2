//
//  SearchViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : BaseViewController

@property (nonatomic ,strong) NSMutableArray *recordArray;
@property (nonatomic ,copy) NSString *keyword;

@end

NS_ASSUME_NONNULL_END
