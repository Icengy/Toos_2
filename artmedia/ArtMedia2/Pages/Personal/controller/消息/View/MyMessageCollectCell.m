//
//  MyMessageCollectCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/5/25.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyMessageCollectCell.h"

@interface MyMessageCollectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelWidthConstraint;
@end

@implementation MyMessageCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    _countLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCollectionType:(NSInteger)collectionType {
    _collectionType = collectionType;
    if (_collectionType) {
        _logoIV.image = ImageNamed(@"icon_discuss");
        _titleLabel.text = @"评论回复";
    }else {
        _logoIV.image = ImageNamed(@"icon_zan");
        _titleLabel.text = @"收到的赞";
    }
}

- (void)setNewCount:(NSInteger)newCount {
    _newCount = newCount;
    if (_newCount) {
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"+ %@", @(_newCount)];
        [_countLabel sizeToFit];
        if (_countLabel.width > 20.0f) {
            _countLabelWidthConstraint.constant = _countLabel.width+10.0f;
        }
    }else {
        _countLabel.hidden = YES;
    }
}

@end
