//
//  GoodsPartItemHeaderView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsPartItemHeaderView.h"

@interface GoodsPartItemHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *authCodeLabel;

@end

@implementation GoodsPartItemHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (GoodsPartItemHeaderView *)shareInstance {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.frame = CGRectMake(0, 0, K_Width, 40.0f);
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _countLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    _authCodeLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}


- (void)setIsHiddenDetail:(BOOL)isHiddenDetail {
    _isHiddenDetail = isHiddenDetail;
    _countLabel.hidden = _isHiddenDetail;
//    _authCodeLabel.hidden = _isHiddenDetail;
    
    _titleLabel.text = _isHiddenDetail?@"免责声明":@"视频认证";
}

- (void)setVideo_count:(NSString *)video_count {
    _video_count = video_count;
    _countLabel.text = [NSString stringWithFormat:@"(%@)",[ToolUtil isEqualToNonNull:_video_count replace:@"0"]];
}

- (void)setVideo_authCode:(NSString *)video_authCode {
    _video_authCode = video_authCode;
    
//    if ([ToolUtil isEqualToNonNull:_video_authCode]) {
//        _authCodeLabel.hidden = NO;
//        _authCodeLabel.text = [NSString stringWithFormat:@"认证编号:%@",_video_authCode];
//    }else {
//        _authCodeLabel.hidden = YES;
//    }
    
}

@end
