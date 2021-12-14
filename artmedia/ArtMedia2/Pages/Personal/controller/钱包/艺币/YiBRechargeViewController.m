//
//  YiBRechargeViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "YiBRechargeViewController.h"

#import "YiBRechargeItemView.h"

#import "AgreementTextView.h"

@interface YiBRechargeViewController () <YiBRechargeItemViewDelegate>
@property (weak, nonatomic) IBOutlet YiBRechargeItemView *itemView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tips1Label;
@property (weak, nonatomic) IBOutlet UILabel *tips2Label;
@property (weak, nonatomic) IBOutlet AgreementTextView *agreementTV;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@end

@implementation YiBRechargeViewController {
    NSInteger _currentIndex;
    NSArray *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *linkText = @"艺币用户协议";
    NSString *allText = [NSString stringWithFormat:@"支付即同意%@",linkText];
    [_agreementTV setAllText:allText
                     allFont:[UIFont addHanSanSC:13.0f fontType:0]
                allTextColor:RGB(153, 153, 153)
                    linkText:linkText
                     linkKey:nil
                    linkFont:nil
               linkTextColor:RGB(53, 151, 214)
                       block:^(NSString * _Nullable linkKey) {
        
    }];
    
    _currentIndex = 0;
    _dataArray = @[@6, @18, @68, @128, @268, @648];
    
    _itemView.delegate = self;
    _itemView.dataArray = _dataArray;
    _itemView.currentIndex = _currentIndex;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"艺币充值";
}

#pragma mark - YiBRechargeItemViewDelegate
- (void)rechargeItemWillDisplayCellWithContentSize:(CGSize)contentSize {
    if (!CGSizeEqualToSize(contentSize, CGSizeZero)) {
        _itemViewHeightConstraint.constant = contentSize.height;
    }
}

- (void)rechargeItemDidSelectedItemAtIndex:(NSInteger)index {
    _currentIndex = index;
    NSLog(@"rechargeItemDidSelectedItemAtIndex = %@", _dataArray[_currentIndex]);
}

#pragma mark -

- (IBAction)clickToConfirm:(id)sender {

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
