//
//  ReportAlertController.m
//  ArtMedia2
//
//  Created by LY on 2020/12/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ReportAlertController.h"

@interface ReportAlertController ()
@property (nonatomic , copy) void(^sureBlock)(void);
@property (nonatomic , copy) void(^cancelBlock)(void);
@end

@implementation ReportAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.0];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//        [self.view addGestureRecognizer:tap];
    }
    return self;
}
- (void)hide{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sureClick:(UIButton *)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
}

- (void)showAlertWithController:(UIViewController *)controller sureClickBlock:(void(^)(void))sureClickBlock{
    self.sureBlock = sureClickBlock;
    [controller.navigationController presentViewController:self animated:YES completion:nil];
}
@end
