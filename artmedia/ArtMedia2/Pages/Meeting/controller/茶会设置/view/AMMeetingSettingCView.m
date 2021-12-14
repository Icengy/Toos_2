//
//  AMMeetingSettingCView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingSettingCView.h"

#import "IMYWebView.h"

@interface AMMeetingSettingCView () <IMYWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet IMYWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webView_height_constraint;

@end

@implementation AMMeetingSettingCView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.webView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
}

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

- (void)setTipsStr:(NSString *)tipsStr {
    _tipsStr = tipsStr;
    
    if ([ToolUtil isEqualToNonNull:_tipsStr]) {
        [self.webView loadHTMLString:[ToolUtil html5StringWithContent:_tipsStr withTitle:nil] baseURL:nil];
        [self.webView.realWebView setNeedsLayout];
    }
}

#pragma mark - IMYWebViewDelegate
- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        NSLog(@"result = %.2f", [result floatValue]);
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.webView_height_constraint.constant = [result floatValue];
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingCCell:didLoadItemsToHeight:)]) {
                [self.delegate settingCCell:self didLoadItemsToHeight:[result floatValue]];
            }
        });
    }];
}

@end
