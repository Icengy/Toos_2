//
//  MessageNewListController.h
//  ArtMedia2
//
//  Created by 名课 on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageNewListController : BaseViewController
//@property (nonatomic , copy) NSString *mtype;
//@property (nonatomic , copy) NSString *userType;
@property (nonatomic , strong) MessageSubModel *model;
@end

NS_ASSUME_NONNULL_END
