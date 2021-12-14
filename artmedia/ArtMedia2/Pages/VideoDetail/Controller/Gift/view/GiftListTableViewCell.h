//
//  GiftListTableViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/26.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftRankListModel : NSObject

@property (nonatomic ,copy) NSString *giver_uid;
@property (nonatomic ,copy) NSString *giver_uname;
@property (nonatomic ,copy) NSString *headimg;
@property (nonatomic ,copy) NSString *num;
@property (nonatomic ,copy) NSString *uname;

@property (nonatomic ,copy) NSString *sort;

@end

@interface GiftListTableViewCell : UITableViewCell

@property (nonatomic ,strong) GiftRankListModel *model;

@end

NS_ASSUME_NONNULL_END
