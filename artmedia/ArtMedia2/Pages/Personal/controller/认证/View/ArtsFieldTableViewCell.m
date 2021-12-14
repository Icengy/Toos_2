//
//  ArtsFieldTableViewCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/24.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtsFieldTableViewCell.h"

#import "IdentifyModel.h"

@interface ArtsFieldTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstFieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondFieldLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelHegihtConstraint;

@end

@implementation ArtsFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _firstFieldLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _secondFieldLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.layer.borderColor = selected?RGB(251, 30, 30).CGColor:Color_Whiter.CGColor;
    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10.0f;
    frame.size.width -= 20.0f;
    frame.size.height -= 10.0f;
    [super setFrame:frame];
}

- (void)setFieldModel:(ArtsFieldModel *)fieldModel {
    _fieldModel = fieldModel;
    _firstFieldLabel.text = [ToolUtil isEqualToNonNullForZanWu:_fieldModel.tcate_name];
    
    __block NSString *secondFieldStr = [NSString new];
    if (_fieldModel.secondcate && _fieldModel.secondcate.count) {
        [_fieldModel.secondcate enumerateObjectsUsingBlock:^(ArtsFieldModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([ToolUtil isEqualToNonNull:obj.scate_name]) {
                secondFieldStr = [NSString stringWithFormat:@"%@%@、", secondFieldStr,obj.scate_name];
            }
        }];
    }
    if (secondFieldStr.length && [secondFieldStr hasSuffix:@"、"]) {
        secondFieldStr = [secondFieldStr substringToIndex:secondFieldStr.length - 1];
    }
    if (![ToolUtil isEqualToNonNull:secondFieldStr]) {
        _secondFieldLabel.hidden = YES;
    }else {
        _secondFieldLabel.hidden = NO;
        _secondFieldLabel.text = secondFieldStr;
        [_secondFieldLabel sizeToFit];
    }
}

@end
