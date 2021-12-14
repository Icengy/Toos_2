//
//  ShortVideoEntranceViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/24.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "ShortVideoEntranceViewController.h"

#import "MainNavigationController.h"

@interface AMVideoEntranceBtn : AMButton

@end

@implementation AMVideoEntranceBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 4.0f;
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGFloat width = self.frame.size.width;
    
    CGFloat imgW = self.imageView.frame.size.width;
    CGFloat imgH = self.imageView.frame.size.height;
    
    CGFloat titleW = self.titleLabel.frame.size.width;
    CGFloat titleH = self.titleLabel.frame.size.height;
    
    CGFloat margin = (self.height-(titleH+imgH+4.0f))/2;
    
    self.imageView.frame = CGRectMake((width - imgH) / 2, margin, imgW, imgH);
    
    self.titleLabel.frame = CGRectMake((width - titleW) / 2, margin+imgH+4.0f, titleW, titleH);
}

@end

@interface ShortVideoEntranceViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBottomConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewBottomConstraint;

@property (weak, nonatomic) IBOutlet AMButton *closeBtn;

@property (weak, nonatomic) IBOutlet AMVideoEntranceBtn *shotBtn;
@property (weak, nonatomic) IBOutlet AMVideoEntranceBtn *editBtn;
@property (weak, nonatomic) IBOutlet AMVideoEntranceBtn *imageBtn;

@end


@implementation ShortVideoEntranceViewController

- (instancetype) init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.view.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.8];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToClose:)];
	tap.delegate = self;
	[self.view addGestureRecognizer:tap];
	
    _shotBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
	_editBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
	_imageBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
	
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
    
	[self.mainView addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(15.0f, 15.0f)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.hidden = NO;
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if ([touch.view isDescendantOfView:self.mainView]) {
		return NO;
	}
	return YES;
}

#pragma mark - 三个按钮的点击代理
- (IBAction)clickToVideoShot:(id)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self.delegate videoEntrance:self clickToLogin:sender];
        return;
    }
    if (![UserInfoManager shareManager].isAuthed) {
        [self.delegate videoEntrance:self clickToAuth:sender];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoEntrance:clickToVideoShot:)]) {
        [self.delegate videoEntrance:self clickToVideoShot:sender];
    }
    
}

- (IBAction)clickToVideoEdit:(id)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self.delegate videoEntrance:self clickToLogin:sender];
        return;
    }
    if (![UserInfoManager shareManager].isAuthed) {
        [self.delegate videoEntrance:self clickToAuth:sender];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoEntrance:clickToVideoLoading:)]) {
        [self.delegate videoEntrance:self clickToVideoLoading:sender];
    }

}

- (IBAction)clickToVideoForImage:(id)sender {
    if (![UserInfoManager shareManager].isLogin) {
        [self.delegate videoEntrance:self clickToLogin:sender];
        return;
    }
    if (![UserInfoManager shareManager].isAuthed) {
        [self.delegate videoEntrance:self clickToAuth:sender];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoEntrance:clickToImageLoading:)]) {
        [self.delegate videoEntrance:self clickToImageLoading:sender];
    }

}

- (IBAction)clickToClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
