//
//  AdressTableViewCell.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/27.
//  Copyright © 2018 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAddressModel;
NS_ASSUME_NONNULL_BEGIN

@interface AdressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineOneView;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet AMButton *markBtn;
@property (weak, nonatomic) IBOutlet AMButton *editBtn;
@property (weak, nonatomic) IBOutlet AMButton *deleteBtn;

@property(nonatomic,strong)void(^markBlock)(void);
@property(nonatomic,strong)void(^deleteBlock)(void);
@property(nonatomic,strong)void(^editBlock)(void);

@property (nonatomic ,strong) MyAddressModel *model;

@end

NS_ASSUME_NONNULL_END
