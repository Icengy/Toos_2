//
//  AuctionApplyNumberPlateSuccessController.m
//  ArtMedia2
//
//  Created by LY on 2020/11/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionApplyNumberPlateSuccessController.h"
#import "AuctionApplyNumberPlateController.h"
#import "AuctionLiveRoomViewController.h"

#import "PlateNumberModel.h"

@interface AuctionApplyNumberPlateSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *backSpecialButton;
@property (weak, nonatomic) IBOutlet UIButton *goAuctionButton;

@property (nonatomic , strong) PlateNumberModel *plateNumberModel;

@end

@implementation AuctionApplyNumberPlateSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removePreviousViewController:[AuctionApplyNumberPlateController class]];
    self.backSpecialButton.layer.borderColor = RGB(228, 228, 228).CGColor;
    self.backSpecialButton.layer.borderWidth = 1;
    self.goAuctionButton.layer.borderColor = RGB(228, 228, 228).CGColor;
    self.goAuctionButton.layer.borderWidth = 1;
    [self selectAuctionUserPlateNumberByCurrentUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/// 查询用户号牌详情
- (void)selectAuctionUserPlateNumberByCurrentUser{
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectAuctionUserPlateNumberByCurrentUser:self.auctionModel.auctionFieldId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.plateNumberModel = [PlateNumberModel yy_modelWithDictionary:response[@"data"]];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}
- (void)setPlateNumberModel:(PlateNumberModel *)plateNumberModel{
    _plateNumberModel = plateNumberModel;
    if (self.payWay == AMPayWayOffline) {
        self.textLabel.text = [NSString stringWithFormat:@"您打款成功后\n就可以用该号牌在专场“%@”进行竞拍，请尽快打款",plateNumberModel.auctionFieldTitle];
    }else{
        self.textLabel.text = [NSString stringWithFormat:@"您可以用该号牌在专场“%@”进行竞拍啦",plateNumberModel.auctionFieldTitle];
    }
    self.numberLabel.text = plateNumberModel.auctionFieldPlateNumber;
}

- (IBAction)backSpecialClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goAuctionClick:(UIButton *)sender {
    __block UIViewController *vc;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[AuctionLiveRoomViewController class]]) {
            vc = obj;
        }
    }];
    if (vc) {
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        AuctionLiveRoomViewController *vc = [[AuctionLiveRoomViewController alloc] init];
        vc.auctionModel = self.auctionModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (IBAction)back:(AMButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
