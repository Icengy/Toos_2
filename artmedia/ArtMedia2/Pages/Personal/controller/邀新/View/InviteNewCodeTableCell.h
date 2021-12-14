//
//  InviteNewCodeTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteNewCodeTableCell : UITableViewCell

@property (nonatomic ,copy) NSString *inviteCodeStr;
@property (nonatomic ,copy) void(^ inviteOtherBlock)(void);

@end

NS_ASSUME_NONNULL_END
