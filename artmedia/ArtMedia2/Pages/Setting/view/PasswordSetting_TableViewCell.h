//
//  PasswordSetting_TableViewCell.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/19.
//  Copyright © 2018 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordSetting_TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet AMTextField *contentTF;

@property(nonatomic,strong)void(^contentStrBlock)(NSString *conetentStr);

@end

NS_ASSUME_NONNULL_END
