//
//  DiscussInfoHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussInfoHeaderView.h"

#import "DiscussItemInfoModel.h"

@interface DiscussInfoHeaderView ()
@property (weak, nonatomic) IBOutlet AMIconImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *autherMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *artsMarkLabel;

@property (weak, nonatomic) IBOutlet AMButton *thumbsCountBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *author_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *author_width;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arts_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arts_width;

@end

@implementation DiscussInfoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_logoIV addBorderWidth:2.0f borderColor:RGB(230, 230, 230)];
    
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _dateLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _autherMarkLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    _artsMarkLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    
    _thumbsCountBtn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    [self setAutherMarkHidden:YES];
    [self setArtsMarkHidden:YES];
}

- (void)setModel:(DiscussItemInfoModel *)model {
    _model = model;
    
    [_logoIV am_setImageWithURL:_model.user_info.headimg placeholderImage:ImageNamed(@"logo")];
    
    _titleLabel.text = [ToolUtil isEqualToNonNullKong:_model.user_info.username];
    _dateLabel.text = [TimeTool disscussTimestampWithTimeStr:_model.addtime];
    
    [_thumbsCountBtn setTitle:[ToolUtil isEqualToNonNull:_model.like_num replace:@"0"] forState:UIControlStateNormal];
    [_thumbsCountBtn setTitle:[ToolUtil isEqualToNonNull:_model.like_num replace:@"0"] forState:UIControlStateSelected];
    
    _thumbsCountBtn.selected = _model.is_liked.boolValue;
    
    [self setAutherMarkHidden:!_model.is_author.boolValue];
    if (model.user_info && model.user_info.utype.integerValue == 3) {
        [self setArtsMarkHidden:NO];
    }else
        [self setArtsMarkHidden:YES];
}

#pragma mark -
- (void)setAutherMarkHidden:(BOOL)isHidden {
    _autherMarkLabel.hidden = isHidden;
    _autherMarkLabel.text = isHidden?@"":@"作者";
   
    _author_leading.constant = isHidden?0.0f:4.0f;
    _author_width.constant = isHidden?0.0f:30.0f;
}

- (void)setArtsMarkHidden:(BOOL)isHidden {
    _artsMarkLabel.hidden = isHidden;
    _artsMarkLabel.text = isHidden?@"":@"艺术家";
   
    _arts_leading.constant = isHidden?0.0f:4.0f;
    _arts_width.constant = isHidden?0.0f:40.0f;
}

- (IBAction)clickToLogo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoHeader:didClickToLogo:withModel:)]) {
        [self.delegate infoHeader:self didClickToLogo:sender withModel:_model];
    }
}

- (IBAction)clickToLike:(AMButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoHeader:didClickToLike:withModel:)]) {
        [self.delegate infoHeader:self didClickToLike:sender withModel:_model];
    }
}


@end
