//
//  IdentityResultViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/28.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "IdentityResultViewController.h"

#import "ArtManagerPageViewController.h"

@interface IdentityResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet AMButton *artBtn;

@end

@implementation IdentityResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.tipsLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    self.artBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
}

- (IBAction)clickToArt:(id)sender {
    [self.navigationController pushViewController:[[ArtManagerPageViewController alloc] init] animated:YES];
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
