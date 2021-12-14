//
//  AMBaseUserHomepageViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMBaseUserHomepageViewController.h"
#import "AMNewArtistHomeViewController.h"
#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"

#import "CustomPersonalModel.h"

@interface AMBaseUserHomepageViewController ()
@property (nonatomic , strong) CustomPersonalViewController *custom;
@property (nonatomic , strong) AMNewArtistHomeViewController *artist;
@end

@implementation AMBaseUserHomepageViewController {
    CustomPersonalModel *_userModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@""] = [UserInfoManager shareManager].uid;
    param[@"artuid"] = self.artuid;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getOtherUserInfo] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
        if (!_userModel) _userModel = [CustomPersonalModel new];
        _userModel = [CustomPersonalModel yy_modelWithJSON:[response objectForKey:@"data"]];
        
        if (_userModel.userData.utype.integerValue > 2 ) {//艺术家
            AMNewArtistHomeViewController * vc = [[AMNewArtistHomeViewController alloc] init];
            vc.artuid = self.artuid;
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            self.artist = vc;
//            [self.navigationController pushViewController:vc animated:YES];
        }else {
            CustomPersonalViewController *custom = [CustomPersonalViewController shareInstance];
            custom.artuid = self.artuid;
            [self addChildViewController:custom];
            [self.view addSubview:custom.view];
            
            self.custom = custom;
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.custom.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    [self.artist.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}


@end
