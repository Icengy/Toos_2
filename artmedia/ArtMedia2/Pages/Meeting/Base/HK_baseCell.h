//
//  HK_baseCell.h
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HK_baseCell : UITableViewCell
@property(nonatomic,copy) void(^baseBlock)(NSDictionary *dic,id model,NSInteger index);
@property (nonatomic,strong)UIView *BgView;
+ (id)cellWithTableView:(UITableView *)tableView andCellIdifiul:(NSString *)cellId;
- (void)configUI;
- (void)layoutUI;
@end

NS_ASSUME_NONNULL_END
