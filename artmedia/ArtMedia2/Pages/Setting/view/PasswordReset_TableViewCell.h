//
//  PasswordReset_TableViewCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/22.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordReset_TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *codeNameLabel;
@property (weak, nonatomic) IBOutlet AMTextField *codeTF;
@property (weak, nonatomic) IBOutlet AMButton *codeBtn;

@property(nonatomic,strong)void(^codeClickBlock)(AMButton *sender);
@property(nonatomic,strong)void(^codeStrBlock)(NSString *codeStr);

@end

NS_ASSUME_NONNULL_END
