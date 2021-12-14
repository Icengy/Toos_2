//
//  MyECoinViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyECoinViewController.h"
#import "ECoinRechargeViewController.h"
#import "ECoinRecordDetailViewController.h"
#import "TYTabButtonPagerController.h"
#import "ECoinSubListViewController.h"
#import "WebViewURLViewController.h"

#import "ECoinModel.h"

@interface MyECoinViewController () <TYPagerControllerDataSource , TYTabPagerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *consumptionButton;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;//充值记录列表的类型按钮
@property (weak, nonatomic) IBOutlet UILabel *ecoinLabel;

@property (weak, nonatomic) IBOutlet UIView *redlineView;
//@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (nonatomic , strong) NSMutableArray <UIButton *>*buttonArray;
@property (strong, nonatomic) TYTabButtonPagerController *tyController;
@property (nonatomic , strong) NSMutableArray *titleArray;
@property (nonatomic , strong) NSMutableArray *childControllerArray;
@property (weak, nonatomic) IBOutlet UIView *listBackView;
@property (nonatomic , strong) ECoinModel *ecoinModel;



@end

@implementation MyECoinViewController

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
        [_buttonArray addObjectsFromArray:@[self.allButton,self.consumptionButton,self.rechargeButton]];
    }
    return _buttonArray;
}
- (TYTabButtonPagerController *)tyController {
    if (!_tyController) {
        _tyController = [[TYTabButtonPagerController alloc] init];
        _tyController.dataSource = self;
        _tyController.delegate = self;
        _tyController.barStyle = TYPagerBarStyleProgressView;
        _tyController.contentTopEdging = 0;
        _tyController.collectionLayoutEdging = ADAptationMargin;
//        _tyController.cellWidth = (K_Width - ADAptationMargin*(self.childControllerArray.count + 1))/self.childControllerArray.count;
        _tyController.cellSpacing = ADAptationMargin;
        _tyController.progressHeight = 3;
        _tyController.normalTextFont = [UIFont addHanSanSC:14.0f fontType:0];
        _tyController.selectedTextFont = [UIFont addHanSanSC:14.0f fontType:0];
        _tyController.progressColor = Color_MainBg;
        _tyController.normalTextColor = UIColorFromRGB(0x999999);
        _tyController.selectedTextColor = Color_Black;
//        _tyController.defaultIndex = self.pageIndex;
        
    } return _tyController;
}
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithArray:@[@"全部",@"消费",@"充值"]];
    }
    return _titleArray;
}
- (NSMutableArray *)childControllerArray{
    if (!_childControllerArray) {
        _childControllerArray = [NSMutableArray array];
        [self.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                ECoinSubListViewController *vc = [[ECoinSubListViewController alloc] init];
                vc.type = ECoinListRecordTypeAll;
                [_childControllerArray addObject:vc];
            }else if (idx == 1){
                ECoinSubListViewController *vc = [[ECoinSubListViewController alloc] init];
                vc.type = ECoinListRecordTypeConsumption;
                [_childControllerArray addObject:vc];
            }else{
                ECoinSubListViewController *vc = [[ECoinSubListViewController alloc] init];
                vc.type = ECoinListRecordTypeRecharge;
                [_childControllerArray addObject:vc];
            }
        }];
        
    }
    return _childControllerArray;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    self.redlineView.layer.cornerRadius = 1.5;
    [self.allButton setTitleColor:RGB(219, 17, 17) forState:UIControlStateNormal];
    [self addChildViewController:self.tyController];
    [self.listBackView addSubview:self.tyController.view];
    
    
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tyController.view.width = self.listBackView.width;
    self.tyController.view.height = self.listBackView.height - 50;
    self.tyController.view.y = 50;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


#pragma mark - request
- (void)loadData{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectUserWalletByUserId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        self.ecoinModel = [ECoinModel yy_modelWithDictionary:response[@"data"]];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}
- (void)setEcoinModel:(ECoinModel *)ecoinModel{
    _ecoinModel = ecoinModel;
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@艺币",ecoinModel.nowVirtualMoney]];
    [attstr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(ecoinModel.nowVirtualMoney.length, 2)];
    self.ecoinLabel.attributedText = attstr;
}

#pragma mark - ButtonClick

- (IBAction)tabClick:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.redlineView.centerX = sender.centerX;
    }];
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == sender) {
            [obj setTitleColor:RGB(219, 17, 17) forState:UIControlStateNormal];
            [self.tyController moveToControllerAtIndex:idx animated:YES];
        }else{
            [obj setTitleColor:RGB(179, 179, 179) forState:UIControlStateNormal];
        }
    }];
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)question:(UIButton *)sender {//问号
    WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_YBSM]];
    webView.navigationBarTitle = @"艺币说明";
    [self.navigationController pushViewController:webView animated:YES];
}
- (IBAction)recharge:(UIButton *)sender {//充值
    ECoinRechargeViewController *vc = [[ECoinRechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return self.childControllerArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index{
    return self.titleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return self.childControllerArray[index];
}

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
    NSLog(@"didScrollToTabPageIndex - %@",@(index));
    UIButton *button = self.buttonArray[index];
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == button) {
            [obj setTitleColor:RGB(219, 17, 17) forState:UIControlStateNormal];
        }else{
            [obj setTitleColor:RGB(179, 179, 179) forState:UIControlStateNormal];
        }
    }];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.redlineView.centerX = button.centerX;
    }];

}
@end
