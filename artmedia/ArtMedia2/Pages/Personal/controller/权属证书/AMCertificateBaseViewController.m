//
//  AMCertificateBaseViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCertificateBaseViewController.h"

#import "AMCertificateAuthedViewController.h"
#import "AMCertificateNonAuthedViewController.h"
#import "WebViewURLViewController.h"

@interface AMCertificateBaseViewController ()

@property (nonatomic, strong) BaseViewController *childViewController;

@end

@implementation AMCertificateBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.navigationItem.title = @"权属证书管理";
    
    AMButton *questionBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    [questionBtn setImage:ImageNamed(@"certificate_question") forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(clickToQuestion:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:questionBtn];
    
    if ([UserInfoManager shareManager].isAuthed) {
        AMCertificateAuthedViewController *authedVC = [[AMCertificateAuthedViewController alloc] init];
        self.childViewController = authedVC;
        
    }else {
        AMCertificateNonAuthedViewController *nonAuthedVC = [[AMCertificateNonAuthedViewController alloc] init];
        self.childViewController = nonAuthedVC;
    }
    if (self.childViewController) {
        [self addChildViewController:self.childViewController];
        [self.view addSubview:self.childViewController.view];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.childViewController) {
        [self.childViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
}

- (void)clickToQuestion:(id)sender {
    /// https://test.ysrmt.cn/h5/ownership/index.html
    
    WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_ownerTips]];
    webView.navigationBarTitle = @"权属证书说明";
    [self.navigationController pushViewController:webView animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
