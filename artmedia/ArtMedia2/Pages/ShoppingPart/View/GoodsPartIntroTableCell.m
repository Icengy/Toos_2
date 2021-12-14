//
//  GoodsPartIntroTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsPartIntroTableCell.h"

#import "VideoGoodsModel.h"

@interface GoodsPartIntroTableCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *price_height_constraint;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonSellLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIStackView *tagStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagStackView_top_constraint;


@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tag1_width_constraint;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tag2_width_constraint;

@property (weak, nonatomic) IBOutlet UILabel *idcardLabel;


@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation GoodsPartIntroTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _priceLabel.font = [UIFont addHanSanSC:25.0f fontType:2];
    _nonSellLabel.font = [UIFont addHanSanSC:25.0f fontType:2];
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _tagLabel1.font = [UIFont addHanSanSC:13.0f fontType:0];
    _tagLabel2.font = [UIFont addHanSanSC:13.0f fontType:0];
    
    _idcardLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    _introLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VideoGoodsModel *)model {
    _model = model;
    
//    NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:[ToolUtil isEqualToNonNull:_model.sellprice replace:@"0"]];
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",[ToolUtil isEqualToNonNull:_model.sellprice replace:@"0"].doubleValue];
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.name];
//    NSString *introStr = @"";
//    if ([ToolUtil isEqualToNonNull:_model.good_created_time]) {
//        introStr = [NSString stringWithFormat:@"%@创作日期：%@",introStr, [ToolUtil isEqualToNonNullKong:_model.good_created_time]];
//    }
//    if ([ToolUtil isEqualToNonNull:_model.describe]) {
//        introStr = [NSString stringWithFormat:@"%@，%@",introStr, [ToolUtil isEqualToNonNullKong:_model.describe]];
//    }
    _introLabel.text = [NSString stringWithFormat:@"创作日期：%@", [ToolUtil isEqualToNonNullKong:_model.good_created_time]];
    if (model.describe.length > 0) {
        self.lineView.hidden = NO;
        self.desLabel.text = model.describe;
        self.desLabel.hidden = NO;
        
    }else{
        self.lineView.hidden = YES;
        self.desLabel.hidden = YES;
    }
    
    
    
    if (_model.good_is_auth.boolValue) {
        _idcardLabel.text = [NSString stringWithFormat:@"艺术品身份证号：%@",[ToolUtil isEqualToNonNullKong:_model.good_auth_code]];
    }else
        _idcardLabel.text = nil;
    
//    _price_height_constraint.constant = _model.status?0.0:44.0f;
//    _price_height_constraint.constant = 44.0f;
    if (_model.good_sell_type) {/// 可售
        if (_model.status) {/// 已售
//            _price_height_constraint.constant = 0.0f;
            _priceLabel.hidden = NO;
            _nonSellLabel.hidden = YES;
        }else {
            _priceLabel.hidden = NO;
            _nonSellLabel.hidden = YES;
        }
    }else {
        _priceLabel.hidden = YES;
        _nonSellLabel.hidden = NO;
    }
}

- (void)setCategoryData:(NSDictionary *)categoryData {
    _categoryData = categoryData;
    
    if (![_categoryData isKindOfClass:[NSDictionary class]]) _categoryData = [NSDictionary new];
    
    _tagLabel1.hidden = ![ToolUtil isEqualToNonNull:[_categoryData objectForKey:@"tcate_name"]];
    _tagLabel2.hidden = ![ToolUtil isEqualToNonNull:[_categoryData objectForKey:@"scate_name"]];
    if (!_tagLabel1.hidden) {
        _tagLabel1.text = [ToolUtil isEqualToNonNullKong:[_categoryData objectForKey:@"tcate_name"]];
         CGFloat tag1Width = [_tagLabel1.text sizeWithFont:_tagLabel1.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _tagLabel1.height)].width;
         if (tag1Width != 0) {
             tag1Width += 10.0f;
             if (tag1Width < 50.0f) tag1Width = 50.0f;
         }
         _tag1_width_constraint.constant = tag1Width;
    }

    if (!_tagLabel2.hidden) {
        _tagLabel2.text = [ToolUtil isEqualToNonNullKong:[_categoryData objectForKey:@"scate_name"]];
        CGFloat tag2Width = [_tagLabel2.text sizeWithFont:_tagLabel2.font andMaxSize:CGSizeMake(CGFLOAT_MAX, _tagLabel2.height)].width;
        if (tag2Width != 0) {
            tag2Width += 10.0f;
            if (tag2Width < 50.0f) tag2Width = 50.0f;
        }
        _tag2_width_constraint.constant = tag2Width;
    }

    if (_tagLabel1.hidden && _tagLabel2.hidden) {
        _tagStackView.hidden = YES;
        _tagStackView_top_constraint.constant = 0.0f;
    }else {
        _tagStackView.hidden = NO;
        _tagStackView_top_constraint.constant = 15.0f;
    }
}

@end
