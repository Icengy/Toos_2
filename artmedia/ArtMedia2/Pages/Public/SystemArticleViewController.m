//
//  SystemArticleViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/18.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SystemArticleViewController.h"

#import "UIViewController+BackButtonHandler.h"

#import "IMYWebView.h"

static NSString *agreementForUserLogin = @"agreementForUserLogin";
static NSString *agreementForArtIdentify = @"agreementForArtIdentify";
static NSString *agreementForShortVideo = @"agreementForShortVideo";

@interface SystemArticleViewController () <UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet IMYWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;
@end

@implementation SystemArticleViewController {
	BOOL _isNavigationBarHidden;
	UIBarStyle _barStyle;
	UIStatusBarStyle _statusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.confirmView.hidden = !_needBottom;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_isNavigationBarHidden = self.navigationController.isNavigationBarHidden;
	[self.navigationController setNavigationBarHidden:NO animated:NO];
    
	if (_needBottom) {
		//禁止返回
		id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
		UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
		[self.view addGestureRecognizer:pan];
	}
	
	//记录
	_barStyle = self.navigationController.navigationBar.barStyle;
	_statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
	//将status bar 文本颜色设置为默认
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self loadData:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
//	if ([ToolUtil isEqualToNonNull:_articleID]) {
//
//	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:_isNavigationBarHidden animated:NO];
//
	//将status bar 还原
	self.navigationController.navigationBar.barStyle = _barStyle;
	[UIApplication sharedApplication].statusBarStyle = _statusBarStyle;
}

#pragma mark -
- (BOOL)navigationShouldPopOnBackButton {
	if (_needBottom) {
		if (_completion) _completion();
	}
	return YES;
}

- (NSString *)get_navigationTitle {
    switch (_articleID.integerValue) {
        case 1:
            return [NSString stringWithFormat:@"%@认证服务协议", AMBundleName];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@用户协议", AMBundleName];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@视频上传用户协议", AMBundleName];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@免责声明", AMBundleName];
            break;
        case 5:
            return [NSString stringWithFormat:@"%@隐私协议", AMBundleName];
            break;
        case 6:
            return [NSString stringWithFormat:@"%@约见会客服务协议", AMBundleName];
            break;
            
        default:
            break;
    }
    return nil;
}

- (IBAction)clickToConfirm:(AMButton *)sender {
	if (_completion) _completion();
	if (self.navigationController) {
		[self.navigationController popViewControllerAnimated:YES];
	}else
		[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"articleCode"] = [ToolUtil isEqualToNonNullKong:_articleID];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getOrderInfoText] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[(NSArray *)[response objectForKey:@"data"] lastObject];
        
        if (data && data.count) {
            [self.navigationItem setTitle:[ToolUtil isEqualToNonNullKong:[data objectForKey:@"articleTitle"]]];
            [self loadHtmlContent:[data objectForKey:@"articleContent"]];
        }
    } fail:nil];
}

- (void)loadHtmlContent:(NSString *_Nullable)content {
	[self.webView loadHTMLString:[ToolUtil html5StringWithContent:content withTitle:nil] baseURL:nil];
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
