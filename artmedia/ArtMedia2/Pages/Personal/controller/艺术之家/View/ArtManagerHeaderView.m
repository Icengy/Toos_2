//
//  ArtManagerHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtManagerHeaderView.h"

@interface ArtManagerHeaderView ()

@property (weak, nonatomic) IBOutlet AMButton *backBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backbtn_top_constraint;

@property (weak, nonatomic) IBOutlet AMIconImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet AMReverseButton *authDataBtn;

@end

@implementation ArtManagerHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (void)setModel:(UserInfoModel *)model{
//
//    _model = model;
//    self.unameLabel.text = model.userData.username;
//    [self.logoIV am_setImageWithURL:model.userData.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
//}

+ (ArtManagerHeaderView *)shareInstance {
    return (ArtManagerHeaderView *)[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _unameLabel.font = [UIFont addHanSanSC:16.0f fontType:2];
    _authDataBtn.titleLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    
    _backbtn_top_constraint.constant = StatusBar_Height;
}

- (CGFloat)contentHeight {
    return self.height;
}

- (void)setModel:(UserInfoModel *)model {
    _model = model;
    [_logoIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    
    _unameLabel.text = [ToolUtil isEqualToNonNull:_model.username replace:@"潮流艺术家"];
    
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedToBack:)]) {
        [self.delegate headerView:self didSelectedToBack:sender];
    }
}

- (IBAction)clickToAuthData:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedToAuthData:)]) {
        [self.delegate headerView:self didSelectedToAuthData:sender];
    }
}


@end
