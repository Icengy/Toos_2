//
//  ImproveDataACell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdentifyModel;
NS_ASSUME_NONNULL_BEGIN

@interface ImproveDataACell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet AMTextField *nameTF;

@property (weak, nonatomic) IBOutlet UIView *fieldView;
@property (weak, nonatomic) IBOutlet UILabel *fieldLabel;
@property (weak, nonatomic) IBOutlet AMTextField *fieldTF;

@property (weak, nonatomic) IBOutlet UIView *positionView;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet AMTextField *positionTF;

@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet AMTextView *introTV;

@property (nonatomic ,strong) IdentifyModel *model;

@property(nonatomic,copy) void(^editDataBlock)(NSString *input, NSInteger controlType);//controlType =0：真实姓名 =1：创作领域 =2：任职机构 =3：个人介绍

@end

NS_ASSUME_NONNULL_END
