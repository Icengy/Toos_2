//
//  JoinClassResultViewVontroller.m
//  ArtMedia2
//
//  Created by LY on 2020/10/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "JoinClassResultViewVontroller.h"

@interface JoinClassResultViewVontroller ()
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *ecoinBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic , copy) void(^completionBlock)(void);
@end

@implementation JoinClassResultViewVontroller
- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)hide{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)sureBlock:(UIButton *)sender {
    if (self.completionBlock) {
        self.completionBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showWithController:(UIViewController *)controller title:(NSString *)title ecoinBalance:(NSString *)ecoinBalance sureButtonTitle:(NSString *)sureButtonTitle completionBlock:(void(^)(void))completionBlock{
    self.contentLabel.text = title;
    self.ecoinBalanceLabel.text = ecoinBalance;
    if (ecoinBalance.length == 0) {
        self.ecoinBalanceLabel.hidden = YES;
    }
    [self.sureButton setTitle:sureButtonTitle forState:UIControlStateNormal];
    self.completionBlock = completionBlock;
    [controller.navigationController presentViewController:self animated:YES completion:nil];
}

@end
