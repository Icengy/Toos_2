//
//  AMMeetingCreateViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingCreateViewController.h"

#import "AMMeetingBookingListViewController.h"

@interface AMMeetingCreateViewController ()
@property (nonatomic ,strong) AMMeetingBookingListViewController *bookingVC;
@end

@implementation AMMeetingCreateViewController


- (AMMeetingBookingListViewController *)bookingVC {
    if (!_bookingVC) {
        _bookingVC = [[AMMeetingBookingListViewController alloc] init];
    }return _bookingVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"邀请预约用户"];
    
    [self addChildViewController:self.bookingVC];
    [self.view addSubview:self.bookingVC.view];
    [self.bookingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.bookingVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
