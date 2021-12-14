//
//  UserListDetailTableViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserListDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AMIconImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet AMButton *userIdentifitionBtn;
@property (weak, nonatomic) IBOutlet AMButton *followedBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeightConstraint;

@property (nonatomic ,assign) NSInteger detailType;//0、关注，1、粉丝
@property (nonatomic ,strong) NSDictionary *model;


@end

NS_ASSUME_NONNULL_END
