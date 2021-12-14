//
//  ArtWorkMainViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/12/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtWorkMainViewController.h"
#import "ArtworkListViewController.h"

@interface ArtWorkMainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *allArtButton;
@property (weak, nonatomic) IBOutlet UIButton *enableBuyButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic , strong) NSArray <UIButton *>*buttonArray;
@end

@implementation ArtWorkMainViewController
- (NSArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSArray alloc] initWithObjects:self.allArtButton,self.enableBuyButton, nil];
    }
    return _buttonArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.allArtButton setTitleColor:RGB(224, 82, 39) forState:UIControlStateSelected];
    [self.allArtButton setTitleColor:RGB(157, 155, 152) forState:UIControlStateNormal];
    
    
    [self.enableBuyButton setTitleColor:RGB(224, 82, 39) forState:UIControlStateSelected];
    [self.enableBuyButton setTitleColor:RGB(157, 155, 152) forState:UIControlStateNormal];
    
    self.allArtButton.selected = YES;
    
    self.contentChildArray = [self getContentChildArray].mutableCopy;
    self.contentCarrier.delegate = self;
    self.contentCarrier.dataSource = self;
    [self addChildViewController:self.contentCarrier];
    [self.view addSubview:self.contentCarrier.view];
    [self.contentCarrier.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(40);
        make.width.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
    }];
    
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentCarrier.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(SafeAreaTopHeight + 20);
        make.width.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
    }];
}

- (NSArray *)getContentChildArray {
  
    NSMutableArray *childArray = @[].mutableCopy;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ArtworkListViewController *subViewController = [[ArtworkListViewController alloc] init];
        switch (idx) {
            case 0:
                subViewController.type = @"1";
                break;
            case 1:
                subViewController.type = @"2";
                break;
           
            default:
                break;
        }
        
        [childArray addObject:subViewController];
    }];
    return childArray.copy;
}


- (IBAction)buttonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.centerX = sender.centerX;
    }];
    
    
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([sender.titleLabel.text isEqualToString:obj.titleLabel.text]) {
            obj.selected = YES;
        }else{
            obj.selected = NO;
        }
    }];
    if ([sender.titleLabel.text isEqualToString:@"全部作品"]) {
        [self.contentCarrier moveToControllerAtIndex:0 animated:YES];
    }else{
        [self.contentCarrier moveToControllerAtIndex:1 animated:YES];
    }
    
    
}
- (NSInteger)numberOfControllersInPagerController {
    return self.contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return nil;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return self.contentChildArray[index];
}

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
//    [self updateBtnUIs:index];
    
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.lineView.centerX = obj.centerX;
            }];
        }else{
            obj.selected = NO;
        }
    }];
}
@end
