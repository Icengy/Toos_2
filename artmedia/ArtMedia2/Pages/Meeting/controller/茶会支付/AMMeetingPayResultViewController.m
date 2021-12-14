//
//  AMMeetingPayResultViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingPayResultViewController.h"

#import "UIViewController+BackButtonHandler.h"

#import <NSDate+BRPickerView.h>

@interface AMMeetingPayResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@end

@implementation AMMeetingPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"支付成功";
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    NSDate *current = [NSDate date];
    NSDate *lastData = [NSDate br_setYear:current.br_year month:(current.br_month + 1) day:current.br_day hour:current.br_hour minute:current.br_minute second:current.br_second];
    _contentLabel.text = [NSString stringWithFormat:@"您已成功约见艺术家%@，预约截止时间：%@", self.artist_name, [NSDate br_stringFromDate:lastData dateFormat:AMDataFormatter2]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)clickToConfirm:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)navigationShouldPopOnBackButton {
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
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
