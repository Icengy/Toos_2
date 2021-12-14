//
//  CommitTableViewCell.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/27.
//  Copyright © 2018 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet AMTextField *textFiled;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property(nonatomic,strong)void(^textFiledBlock)(NSString*text);

@end

NS_ASSUME_NONNULL_END
