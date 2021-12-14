//
//  SystemArticleViewController.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/18.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^agreeAgreementBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface SystemArticleViewController : BaseViewController


@property (nonatomic ,copy) NSString *articleID;
@property (nonatomic ,assign) BOOL needBottom;
@property (nonatomic ,copy) agreeAgreementBlock completion;

@end

NS_ASSUME_NONNULL_END
