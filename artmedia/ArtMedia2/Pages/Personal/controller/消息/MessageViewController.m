//
//  MessageViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/28.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "MessageViewController.h"

#import "AMEmptyView.h"

#import "AMSegmentedControl.h"
#import "MyMessageTableViewCell.h"
#import "MyMessageCollectCell.h"

#import "SystemMessageDetailViewController.h"
#import "MessageListViewController.h"
#import "DiscussReplyViewController.h"
#import "TYPagerController.h"
#import "MessageSubViewController.h"

#import "MessageCountModel.h"

@interface MessageViewController ()<TYPagerControllerDelegate , TYPagerControllerDataSource>
@property (strong , nonatomic) TYPagerController * tyPagerController;
@property (weak, nonatomic) IBOutlet AMSegmentedControl *segmentControl;
@property (strong , nonatomic) NSMutableArray * controllerArray;
@property (weak, nonatomic) IBOutlet UIView *customNavBar;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *zanButton;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *commentButton;

@property (strong, nonatomic) MessageCountModel *countModel;
@end

@implementation MessageViewController

- (NSMutableArray *)controllerArray{
    if (!_controllerArray) {
        _controllerArray = [NSMutableArray array];
        MessageSubViewController * vc1 = [[MessageSubViewController alloc] init];
        vc1.type = @"1";
        [_controllerArray addObject:vc1];
        if ([UserInfoManager shareManager].isArtist) {
            MessageSubViewController * vc2 = [[MessageSubViewController alloc] init];
            vc2.type = @"2";
            [_controllerArray addObject:vc2];
        }
    }
    return _controllerArray;
}
- (TYPagerController *)tyPagerController
{
    if (!_tyPagerController) {
        _tyPagerController = [[TYPagerController alloc]init];
        _tyPagerController.delegate = self;
        _tyPagerController.dataSource = self;
    }
    return _tyPagerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![UserInfoManager shareManager].isLogin) {
        self.customNavBar.hidden = NO;
    }else {
        if ([UserInfoManager shareManager].isArtist) {
            self.customNavBar.hidden = NO;
        }else{
            self.customNavBar.hidden = YES;
        }
    }
    [self.navigationController setNavigationBarHidden:!self.customNavBar.hidden animated:YES];
    self.navigationItem.title = @"消息中心";
    
    [self loadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tyPagerController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setUpStyle{
    
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    [self addChildViewController:self.tyPagerController];
    [self.view addSubview:self.tyPagerController.view];
    [self.tyPagerController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.segmentControl setSelectedSegmentIndex:0];
    [self.segmentControl addTarget:self action:@selector(clickSegmentControl:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: RGB(22, 22, 26),NSFontAttributeName:[UIFont addHanSanSC:14.0 fontType:0]} forState:UIControlStateSelected];
    [self.segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: RGB(154, 154, 154),NSFontAttributeName:[UIFont addHanSanSC:14.0 fontType:0]} forState:UIControlStateNormal];
    for(UIView *subview in self.segmentControl.subviews) {
        if([NSStringFromClass(subview.class) isEqualToString:@"UISegment"]) {
            for(UIView *segmentSubview in subview.subviews) {
                if([NSStringFromClass(segmentSubview.class) isEqualToString:@"UISegmentLabel"]) {
                    UILabel *label = (id)segmentSubview;
                    [label adjustsFontSizeToFitWidth];
                }
            }
        }
    }
    
    [self.zanButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    self.zanButton.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.zanButton.needPlus = YES;
    
    [self.commentButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    self.commentButton.needPlus = YES;
    
}

- (void)loadData {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUnreadCount] needHUD:NO params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *dict = (NSDictionary *)[response objectForKey:@"data"];
        if (dict && dict.count) {
            AMUserDefaultsSetObject(dict, AMUserMsg);
            AMUserDefaultsSynchronize;
            self.countModel = [MessageCountModel yy_modelWithJSON:dict];
        }
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
    }];
}

- (void)setCountModel:(MessageCountModel *)countModel {
    _countModel = countModel;
    
    self.zanButton.badgeNum = [_countModel.unread_fabulous integerValue];
    self.commentButton.badgeNum = [_countModel.unread_comments_num integerValue];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController{
    return self.controllerArray.count;
}

// viewController at index in pagerController
- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index{
    return self.controllerArray[index];
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    [self.segmentControl setSelectedSegmentIndex:toIndex];
}

#pragma mark -
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSegmentControl:(UISegmentedControl *)seg{
    [self.tyPagerController moveToControllerAtIndex:seg.selectedSegmentIndex animated:YES];
}

- (IBAction)zanClick:(AMButton *)sender {
    MessageListViewController * vc = [[MessageListViewController alloc]init];
    vc.listStyle = MessageDetailListStyleCollect;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)replayClick:(AMButton *)sender {
    [self.navigationController pushViewController:[[DiscussReplyViewController alloc]init] animated:YES];
}

@end
