//
//  LivingRoomMainViewController.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/1.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "LivingRoomMainViewController.h"
#import "LivingRoomSubViewController.h"
#import "AMBaseUserHomepageViewController.h"

#import <objc/runtime.h>

#import "LivingRoomButton.h"
#import "LivingRoomModel.h"
#import "LivingRoomCell.h"

#define AMLivingRoomBtnTag 20201020

@interface LivingRoomMainViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet LivingRoomButton *allButton;
@property (weak, nonatomic) IBOutlet LivingRoomButton *artistButton;
@property (weak, nonatomic) IBOutlet LivingRoomButton *movieStarButton;
@property (weak, nonatomic) IBOutlet LivingRoomButton *singerButton;

@property (strong, nonatomic) NSArray <LivingRoomButton *> *buttonArray;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation LivingRoomMainViewController

- (NSArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSArray arrayWithObjects:_allButton,_artistButton,_movieStarButton,_singerButton, nil];
    }
    return _buttonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    self.contentChildArray = [self getContentChildArray].mutableCopy;
    self.contentCarrier.delegate = self;
    self.contentCarrier.dataSource = self;
    [self addChildViewController:self.contentCarrier];
    [self.view addSubview:self.contentCarrier.view];
    [self.contentCarrier.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.width.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
    }];
    
    [self updateBtnUIs:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentCarrier.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.width.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
    }];
}

- (NSArray *)getContentChildArray {
    self.contentTitleArray = [self getContentTitleArray].mutableCopy;
    
    NSMutableArray *childArray = @[].mutableCopy;
    [self.contentTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LivingRoomSubViewController *subViewController = [[LivingRoomSubViewController alloc] init];
        switch (idx) {
            case 0:
                subViewController.utype = @"0";
                break;
            case 1:
                subViewController.utype = @"3";
                break;
            case 2:
                subViewController.utype = @"4";
                break;
            case 3:
                subViewController.utype = @"5";
                break;
                
            default:
                break;
        }
        
        [childArray addObject:subViewController];
    }];
    return childArray.copy;
}

- (NSArray *)getContentTitleArray {
    return @[@"全部", @"艺术家", @"影视明星", @"歌手"];
}

#pragma mark -
- (IBAction)buttonClick:(UIButton *)sender {
    NSInteger tag = sender.tag - AMLivingRoomBtnTag;
    [self updateBtnUIs:tag];

    [self.contentCarrier moveToControllerAtIndex:tag animated:YES];
}

- (void)updateBtnUIs:(NSInteger)tag {
    __block LivingRoomButton *btn;
    [self.buttonArray enumerateObjectsUsingBlock:^(LivingRoomButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == tag) {
            btn = obj;
            [UIView animateWithDuration:0.3 animations:^{
                obj.transform = CGAffineTransformMakeScale(1.25, 1.25);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                obj.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowImageView.centerX = btn.centerX + 15.0f;
    }];
}

#pragma mark -
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
    [self updateBtnUIs:index];
}

+ (BOOL)accessInstanceVariablesDirectly{
    return YES;
}

#pragma mark -
- (void)reloadCurrent:(NSNotification *)notification {
    LivingRoomSubViewController *subVC = (LivingRoomSubViewController *)[self.contentChildArray objectAtIndex:self.contentCarrier.curIndex];
    [subVC reloadCurrent:notification];
}


// transition from index to index with progress
//- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
//    NSLog(@"fromIndex : %d",fromIndex);
//    NSLog(@"progress : %f",progress);
//}


@end
