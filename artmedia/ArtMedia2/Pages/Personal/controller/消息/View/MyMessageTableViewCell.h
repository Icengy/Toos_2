//
//  MyMessageTableViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface MyMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet AMButton *isReadedBtn;

@property (nonatomic ,strong) SystemMessageModel *model;

@end

NS_ASSUME_NONNULL_END
