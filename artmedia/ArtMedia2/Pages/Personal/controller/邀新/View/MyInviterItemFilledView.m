//
//  MyInviterItemFilledView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyInviterItemFilledView.h"

#import "InviteInfoModel.h"

@interface MyInviterItemFilledView ()
@property (weak, nonatomic) IBOutlet AMIconImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end

@implementation MyInviterItemFilledView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
    _codeLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
}

- (void)setFilledModel:(InviteInfoModel *)filledModel {
    _filledModel = filledModel;
    if (_filledModel) {
        [self.iconIV am_setImageWithURL:filledModel.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
        
        self.nameLabel.text = [ToolUtil isEqualToNonNull:_filledModel.uname replace:@"邀请人"];
        self.codeLabel.text = [NSString stringWithFormat:@"邀请码：%@", [ToolUtil isEqualToNonNullKong:_filledModel.invitation_code]];
    }
}


@end
