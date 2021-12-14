//
//  BlacklistTableViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2020/1/9.
//  Copyright © 2020 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlacklistModel : NSObject

@property(nonatomic ,copy)NSString *addtime;
@property(nonatomic ,copy)NSString *headimg;
@property(nonatomic ,copy)NSString *collect_id;
@property(nonatomic ,copy)NSString *name;
///1专场/2拍品/3即时拍/4投资拍品/5短视频/6拉黑用户
@property(nonatomic ,copy)NSString *collect_type;
@property(nonatomic ,copy)NSString *ID;
///1喜欢 2点赞 3拉黑
@property(nonatomic ,copy)NSString *type;
@property(nonatomic ,copy)NSString *uid;

@end

@interface BlacklistTableViewCell : UITableViewCell

@property (nonatomic ,strong) BlacklistModel *model;
@property(nonatomic,copy) void(^removeBlock)(BlacklistModel *model);

@end

NS_ASSUME_NONNULL_END
