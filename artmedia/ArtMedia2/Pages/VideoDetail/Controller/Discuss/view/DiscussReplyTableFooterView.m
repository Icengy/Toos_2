//
//  DiscussReplyTableFooterView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/6.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussReplyTableFooterView.h"

@interface DiscussReplyTableFooterView ()
@property (weak, nonatomic) IBOutlet AMButton *clickBtn;

@end

@implementation DiscussReplyTableFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _clickBtn.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
}

- (void)setMoreCount:(NSInteger)moreCount {
    _moreCount = moreCount;
    [_clickBtn setTitle:[NSString stringWithFormat:@"查看全部%@条回复>", @(_moreCount)] forState:UIControlStateNormal];
}

- (IBAction)clickToMore:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerView:didSelectedMore:)]) {
        [self.delegate footerView:self didSelectedMore:sender];
    }
}


@end
