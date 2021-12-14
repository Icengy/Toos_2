//
//  PersonalEditCollectionCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/17.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoListModel;
@class GradientButton;

NS_ASSUME_NONNULL_BEGIN

@interface PersonalEditCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *videoCoverIV;
@property (weak, nonatomic) IBOutlet AMButton *shoppenBtn;
@property (weak, nonatomic) IBOutlet GradientButton *videoTimeLabel;
@property (weak, nonatomic) IBOutlet GradientButton *playCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkStatusWidthContstraint;

@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;

@property (weak, nonatomic) IBOutlet AMButton *editBtn;
@property (weak, nonatomic) IBOutlet AMButton *deleteBtn;
@property (weak, nonatomic) IBOutlet AMButton *statusBtn;

@property (nonatomic ,strong) VideoListModel *model;


@property (nonatomic ,copy) void(^ editVideoBlock)(VideoListModel *model);
@property (nonatomic ,copy) void(^ deleteVideoBlock)(VideoListModel *model);

@end

NS_ASSUME_NONNULL_END
