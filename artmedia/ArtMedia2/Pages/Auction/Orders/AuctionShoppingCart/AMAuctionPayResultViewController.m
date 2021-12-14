//
//  AMAuctionPayResultViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionPayResultViewController.h"
#import "AMAuctionOrderViewController.h"

#import "AMAuctionPayResultTableCell.h"
#import "IMYWebView.h"

#import "AMAuctionOrderModel.h"

@interface AMAuctionPayResultViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;

@property (weak, nonatomic) IBOutlet UILabel *keyOnline;
@property (weak, nonatomic) IBOutlet UILabel *keyOffline;

@property (weak, nonatomic) IBOutlet UILabel *tipsOnline;
@property (weak, nonatomic) IBOutlet UILabel *tipsOffline;

@property (weak, nonatomic) IBOutlet AMButton *toOrderDetailBtn;
@property (weak, nonatomic) IBOutlet AMButton *toHomeBtn;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

//@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet IMYWebView *webView;
@end

@implementation AMAuctionPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.keyOnline.font = [UIFont addHanSanSC:18.0 fontType:2];
    self.keyOffline.font = [UIFont addHanSanSC:18.0 fontType:2];
    self.tipsOnline.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.tipsOffline.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.warningLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    
    self.toOrderDetailBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    self.toHomeBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    
    if (self.payWay == AMPayWayOffline) {
        self.keyOnline.hidden = YES;
        self.tipsOnline.hidden = YES;
        self.webView.hidden = NO;
        self.warningLabel.hidden = YES;
        
        self.tipsOffline.text = [NSString stringWithFormat:@"您已选择下线转账，请尽快支付 ¥%@\n超过3日未打款，则订单将自动关闭",self.priceStr];
        
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[ApiUtil_H5Header h5_agreement:@"XXZZXX"]]]];
    }else {
        self.keyOffline.hidden = YES;
        self.tipsOffline.hidden = YES;
        self.webView.hidden = YES;
        self.warningLabel.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMAuctionPayResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMAuctionPayResultTableCell class]) forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark -
- (IBAction)clickToOrderDetail:(id)sender {
    [self.navigationController pushViewController:[[AMAuctionOrderViewController alloc] init] animated:YES];
}

- (IBAction)clickToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
