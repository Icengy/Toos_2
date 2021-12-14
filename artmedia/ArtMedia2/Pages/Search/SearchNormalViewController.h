//
//  SearchNormalViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^TagClickBlock)(NSString *keyword);

@interface SearchNormalViewController : BaseViewController

@property (nonatomic ,copy) TagClickBlock tagClickBlock;
@property (nonatomic ,strong) NSArray *tagArray;

- (void)hideSubView:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
