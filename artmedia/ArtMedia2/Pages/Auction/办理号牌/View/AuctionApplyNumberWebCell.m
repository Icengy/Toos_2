//
//  AuctionApplyNumberWebCell.m
//  ArtMedia2
//
//  Created by LY on 2020/12/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionApplyNumberWebCell.h"
#import <WebKit/WebKit.h>

@interface AuctionApplyNumberWebCell ()<WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end
@implementation AuctionApplyNumberWebCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ApiUtil_H5Header h5_agreement:@"BZJSM"]]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUrl:(NSString *)url{
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ApiUtil_H5Header h5_agreement:@"BZJSM"]]]];
    
    
}
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    
//    
//    // 不执行前段界面弹出列表的JS代码，关闭系统的长按保存图片
//    [self evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
//    
//   
//    //    document.body.scrollHeight（不准）   document.body.offsetHeight;(好)
//    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
//      NSString *heightStr = [NSString stringWithFormat:@"%@",Result];
//            
//            //必须加上一点
//            CGFloat height = heightStr.floatValue+15.00;
//            //网页加载完成
//           NSLog(@"新闻加载完成网页高度：%f",height);
//}
@end
