//
//  GoodsPartWebTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsPartWebTableCell.h"

#import "IMYWebView.h"

@interface GoodsPartWebTableCell () <IMYWebViewDelegate, IMYWebViewDataSource>
@property (weak, nonatomic) IBOutlet IMYWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *web_height_constraint;

@end

@implementation GoodsPartWebTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.webView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWebInfo:(NSDictionary *)webInfo {
    _webInfo = webInfo;
    if (_webInfo && [_webInfo isKindOfClass:[NSDictionary class]] && _webInfo.count) {
        [self.webView loadHTMLString:[ToolUtil html5StringWithContent:[ToolUtil isEqualToNonNullKong:[_webInfo objectForKey:@"content"]] withTitle:nil] baseURL:nil];
    }
}

#pragma mark - IMYWebViewDelegate
- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error--- %@", error);
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView {
    //获取网页的高度
    /// document.body.scrollHeight
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error){
        NSLog(@"result = %.2f", [result floatValue]);
        if (self.needWeb) {
            _web_height_constraint.constant = [result floatValue];
        }else
            _web_height_constraint.constant = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(webCell:didFinishLoadWithScrollHeight:)]) {
            [self.delegate webCell:self didFinishLoadWithScrollHeight:_web_height_constraint.constant];
        }
    }];
}


@end
