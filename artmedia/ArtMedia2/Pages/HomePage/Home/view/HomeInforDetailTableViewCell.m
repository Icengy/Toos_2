//
//  HomeInforDetailTableViewCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/2/25.
//  Copyright © 2020 lcy. All rights reserved.
//

#import "HomeInforDetailTableViewCell.h"

#import "HomeInforModel.h"

@interface HomeInforDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showIV;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation HomeInforDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.font = [UIFont addHanSanSC:16.0f fontType:1];
    _titleLabel.numberOfLines = 2;
    _readCountLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _timeLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    
    _showIV.layer.cornerRadius = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(HomeInforModel *)model {
    _model = model;
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.title];
    [_showIV am_setImageWithURL:_model.banner];
    
    _readCountLabel.text = [NSString stringWithFormat:@"%@  阅读", [ToolUtil isEqualToNonNull:_model.number replace:@"0"]];
    if (_model.addtime.doubleValue > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%@前", [TimeTool getDifferenceToCurrentSinceTimeStamp:_model.addtime.doubleValue]];
    }
}

@end
