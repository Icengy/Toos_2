//
//  ImproveDataCCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImproveDataCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHightConstraint;

- (void)setContentHeight:(CGFloat )reasonHeight reason:(NSString *)reasonStr;

@property (nonatomic ,assign) BOOL isShowDetail;

@end

NS_ASSUME_NONNULL_END
