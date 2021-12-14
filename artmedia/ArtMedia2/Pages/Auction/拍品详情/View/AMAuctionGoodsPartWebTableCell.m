//
//  AMAuctionGoodsPartWebTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/27.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionGoodsPartWebTableCell.h"

#import "IMYWebView.h"

@interface AMAuctionGoodsPartWebTableCell () <IMYWebViewDelegate, IMYWebViewDataSource>
@property (weak, nonatomic) IBOutlet IMYWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *web_height_constraint;

@end

@implementation AMAuctionGoodsPartWebTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.webView.delegate = self;
    self.webView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWebUrl:(NSString *)webUrl {
    _webUrl = webUrl;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
}

- (void)webView:(IMYWebView *)webView didSelectedGetPageHeightMethod:(id)data {
    CGFloat resultHeight = 0.0;
    if (data && [data count]) {
        resultHeight = [[data objectForKey:@"data"] floatValue];
    }
    _web_height_constraint.constant = resultHeight;
    if (self.delegate && [self.delegate respondsToSelector:@selector(webCell:didFinishLoadWithScrollHeight:)]) {
        [self.delegate webCell:self didFinishLoadWithScrollHeight:_web_height_constraint.constant];
    }
}

@end
