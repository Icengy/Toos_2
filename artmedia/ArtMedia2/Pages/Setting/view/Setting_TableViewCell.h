//
//  Setting_TableViewCell.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/16.
//  Copyright © 2018 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Setting_TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextImage;
@property (weak, nonatomic) IBOutlet UILabel *cashImage;

@end

NS_ASSUME_NONNULL_END
