//
//  HK_appointmentFootView.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_appointmentFootView.h"

#import "IMYWebView.h"

@interface HK_appointmentFootView () <IMYWebViewDelegate>

@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet IMYWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webView_hegiht_constraint;

@end

@implementation HK_appointmentFootView

+ (HK_appointmentFootView *)shareInstance {
    return (HK_appointmentFootView *)[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)setTipsStr:(NSString *)tipsStr {
    _tipsStr = tipsStr;
    
    if ([ToolUtil isEqualToNonNull:_tipsStr]) {
        [self.webView loadHTMLString:[ToolUtil html5StringWithContent:_tipsStr withTitle:nil] baseURL:nil];
        [self.webView.realWebView setNeedsLayout];
    }
}

#pragma mark - IMYWebViewDelegate
- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        NSLog(@"result = %.2f", [result floatValue]);
        CGFloat footerHeight = [result floatValue] + 10.0f;
        if (footerHeight == self.footerHeight) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.webView_hegiht_constraint.constant = footerHeight;
            if (self.delegate && [self.delegate respondsToSelector:@selector(footerCell:didLoadItemsWithHeight:)]) {
                [self.delegate footerCell:self didLoadItemsWithHeight:footerHeight];
            }
        });
    }];
}

@end
