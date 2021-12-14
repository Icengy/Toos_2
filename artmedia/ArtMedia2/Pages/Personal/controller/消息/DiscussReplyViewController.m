//
//  DiscussReplyViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussReplyViewController.h"

#import "TYTabButtonPagerController.h"

#import "MessageListViewController.h"

#import "PersonalListTitleView.h"

@interface DiscussReplyViewController () <TYPagerControllerDataSource, TYTabPagerControllerDelegate, MessageListViewControllerDelegate>

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@property (nonatomic ,strong) PersonalListTitleView *headerView;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,strong) NSMutableArray *badgeArray;

@end

@implementation DiscussReplyViewController

- (PersonalListTitleView *)headerView {
    if (_headerView) return _headerView;
    _headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PersonalListTitleView class]) owner:nil options:nil].lastObject;
    _headerView.frame = CGRectMake(0, 0, K_Width, 44.0f);
    _headerView.dataArray = _contentTitleArray.copy;
    _headerView.badges = _badgeArray.copy;
    @weakify(self);
    _headerView.clickIndexBlock = ^(NSInteger index) {
        @strongify(self);
        self.currentIndex = index;
        [self.contentView moveToControllerAtIndex:self.currentIndex animated:YES];
    };
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _badgeArray = @[@"0", @"0"].mutableCopy;
    _contentTitleArray = [self getContentTitleArray].mutableCopy;
    _contentChildArray = [self getContentChildArray].mutableCopy;
    
    //添加主视图
    [self addChildViewController:self.contentView];
    [self.view addSubview:self.contentView.view];
    
    [self.view insertSubview:self.headerView aboveSubview:self.contentView.view];
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(StatusNav_Height);
        make.left.right.equalTo(self.view);
        make.height.offset(44.0f);
    }];
    [self.contentView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"评论回复";
}


- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.contentView moveToControllerAtIndex:_currentIndex animated:YES];
}

#pragma mark -
- (NSArray *)getContentChildArray {
    MessageListViewController *discussVC = [[MessageListViewController alloc] init];
    discussVC.listStyle = MessageDetailListStyleDiscuss;
    discussVC.delegate = self;
    
    MessageListViewController *replyVC = [[MessageListViewController alloc] init];
    replyVC.listStyle = MessageDetailListStyleReply;
    replyVC.delegate = self;
    
    return @[discussVC ,replyVC];
}

- (NSArray *)getContentTitleArray {
    return @[@"评论", @"回复"];
}

#pragma mark -- TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return _contentTitleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return _contentChildArray[index];
}

- (void)pagerController:(TYTabPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index {
    NSLog(@"didScrollToTabPageIndex - %@",@(index));
    self.currentIndex = index;
    self.headerView.currentIndex = self.currentIndex;
}

#pragma mark - MessageListViewControllerDelegate
- (void)messagelistVC:(MessageListViewController *)messageVC updateUnreadCount:(NSDictionary *)unreadInfo {
    if (_badgeArray.count) [_badgeArray removeAllObjects];
    [_badgeArray addObjectsFromArray:@[@"0", @"0"]];
    if ([unreadInfo objectForKey:@"unread_comment_count"]) {
        [_badgeArray replaceObjectAtIndex:0 withObject:[ToolUtil isEqualToNonNull:unreadInfo[@"unread_comment_count"] replace:@"0"]];
    }
    if ([unreadInfo objectForKey:@"unread_reply_count"]) {
        [_badgeArray replaceObjectAtIndex:1 withObject:[ToolUtil isEqualToNonNull:unreadInfo[@"unread_reply_count"] replace:@"0"]];
    }
    self.headerView.badges = _badgeArray.copy;
}

#pragma mark -
- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        _contentView.contentTopEdging = 0.0f;
        _contentView.delegate = self;
        _contentView.dataSource = self;
        
    } return _contentView;
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
