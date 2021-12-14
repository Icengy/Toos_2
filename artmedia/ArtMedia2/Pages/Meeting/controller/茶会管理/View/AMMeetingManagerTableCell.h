//
//  AMMeetingManagerTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HK_tea_managerModel;
@class AMMeetingManagerTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol AMMeetingManagerDelegate <NSObject>

@required
- (void)managerCell:(AMMeetingManagerTableCell *)managerCell didSelectedToDetail:(id)sender;
- (void)managerCell:(AMMeetingManagerTableCell *)managerCell didSelectedToEnterRoom:(id)sender;
- (void)managerCell:(AMMeetingManagerTableCell *)managerCell didSelectedToLookInvtation:(id)sender;

@end

@interface AMMeetingManagerTableCell : UITableViewCell

@property (nonatomic,weak) id <AMMeetingManagerDelegate> delegate;
@property (nonatomic,strong) HK_tea_managerModel *model;

@end

NS_ASSUME_NONNULL_END
