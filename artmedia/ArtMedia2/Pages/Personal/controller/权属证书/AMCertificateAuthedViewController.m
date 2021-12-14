//
//  AMCertificateAuthedViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCertificateAuthedViewController.h"

#import "AMCertificateListViewController.h"
#import "TYTabButtonPagerController.h"

@interface AMCertificateAuthedViewController () <TYPagerControllerDelegate, TYPagerControllerDataSource>

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@end

@implementation AMCertificateAuthedViewController

- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        _contentView.dataSource = self;
        _contentView.barStyle = TYPagerBarStyleCoverView;
        
        _contentView.contentTopEdging = NavBar_Height;
        _contentView.collectionLayoutEdging = ADAptationMargin;
        _contentView.cellWidth = (K_Width - ADAptationMargin*(_contentChildArray.count + 1))/_contentChildArray.count;
        _contentView.cellSpacing = ADAptationMargin;
        
        _contentView.normalTextFont = [UIFont addHanSanSC:15.0f fontType:0];
        _contentView.selectedTextFont = [UIFont addHanSanSC:15.0f fontType:0];
        
        _contentView.customShadowColor = UIColor.clearColor;
        _contentView.progressColor = UIColorFromRGB(0xF5F5F5);
        _contentView.normalTextColor = UIColorFromRGB(0x999999);
        _contentView.selectedTextColor = UIColorFromRGB(0xE22020);
        _contentView.defaultIndex = self.pageIndex;
        
    } return _contentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.contentChildArray = [self getContentChildArray].mutableCopy;

    [self addChildViewController:self.contentView];
    [self.view addSubview:self.contentView.view];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(StatusNav_Height);
    }];
}

#pragma mark -
- (NSArray *)getContentChildArray {
    self.contentTitleArray = [self getContentTitleArray].mutableCopy;
    NSMutableArray *customArray = [NSMutableArray new];
    for (int i = 0; i < 3; i ++) {
        AMCertificateListViewController *listVC = [[AMCertificateListViewController alloc] init];
        listVC.style = (AMCertificateStyle)i;
        [customArray insertObject:listVC atIndex:customArray.count];
    }
    return customArray;
}

- (NSArray *)getContentTitleArray {
    return @[@"全部", @"持有中", @"已吊销"];
}

- (NSInteger)numberOfControllersInPagerController {
    return self.contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return self.contentTitleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return self.contentChildArray[index];
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
