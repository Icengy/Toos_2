//
//  ReceivableBlankTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/28.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ReceivableBlankTableCell.h"

#import "ReceivableModel.h"

@interface ReceivableBlankTableCell ()
@property (weak, nonatomic) IBOutlet AMButton *nameBtn;

@property (nonatomic, strong) CAShapeLayer *border;
@end

@implementation ReceivableBlankTableCell

- (CAShapeLayer *)border {
    if (!_border) {
        _border = [CAShapeLayer layer];
        _border.strokeColor = RGB(230, 230, 230).CGColor;
        _border.cornerRadius = 4.0f;
        _border.fillColor = nil;
        _border.lineDashPattern = @[@4, @2];
    }
    return _border;
}

- (void)drawRect:(CGRect)rect {
    [self.border removeFromSuperlayer];
    self.border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.border.frame = self.bounds;
    [self.layer addSublayer:self.border];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameBtn.titleLabel.font = [UIFont addHanSanSC:20.0f fontType:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    frame.size.height -= 10.0f;
    [super setFrame:frame];
}

- (void)setReceiveType:(NSInteger)receiveType {
    _receiveType = receiveType;
    if (_receiveType) {
        [_nameBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    }else {
        if ([UserInfoManager shareManager].isArtist) {
            [_nameBtn setTitle:@"添加银行卡（经纪人）" forState:UIControlStateNormal];
        }else
            [_nameBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    }
}

- (void)setModel:(ReceivableModel *)model {
    _model = model;
    if (_model.account_type.integerValue == 3) {
        [_nameBtn setTitle:@"添加银行卡（经纪人）" forState:UIControlStateNormal];
    }else
        [_nameBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
}

- (IBAction)clickToAddNew:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableCell:didClickToAddNewWithModel:)]) {
        [self.delegate tableCell:self didClickToAddNewWithModel:self.model];
    }
}


@end
