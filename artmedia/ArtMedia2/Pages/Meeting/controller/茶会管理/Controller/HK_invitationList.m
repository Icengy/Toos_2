//
//  HK_invitationList.m
//  ArtMedia2
//
//  Created by guohongkai on 2020/8/21.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "HK_invitationList.h"
#import "HK_invitationListVC.h"

#import "TYTabButtonPagerController.h"
#import "AMMeetingBookingListViewController.h"

@interface HK_invitationList ()<TYPagerControllerDataSource>

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIView *contentCarrier;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet AMButton *inviteBtn;

@property (strong, nonatomic)NSArray<NSString *> *titles;
@property (strong, nonatomic)NSArray *childVC;

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@end

@implementation HK_invitationList {
    /// 是否可以继续邀请
    BOOL _canInvite;
    /// 当前会客参会人数
    NSInteger _currentCount;
    /// 当前会客开始时间
    NSString *_meetingBeginDate;
}

- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        _contentView.dataSource = self;
        _contentView.barStyle = TYPagerBarStyleProgressView;
        _contentView.contentTopEdging = NavBar_Height;
        _contentView.collectionLayoutEdging = ADAptationMargin;
        _contentView.cellWidth = (K_Width - ADAptationMargin*(self.childVC.count + 1))/self.childVC.count;
        _contentView.cellSpacing = ADAptationMargin;
        _contentView.progressHeight = 3;
        _contentView.normalTextFont = [UIFont addHanSanSC:16.0f fontType:0];
        _contentView.selectedTextFont = [UIFont addHanSanSC:16.0f fontType:1];
        _contentView.progressColor = Color_MainBg;
        _contentView.normalTextColor = RGB(122, 129, 153);
        _contentView.selectedTextColor = Color_Black;
        
    } return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self createChildVC];
    [self loadData:nil];
}
- (void)configUI{
    self.navigationItem.title = @"邀请名单";
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    self.topLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    self.inviteBtn.titleLabel.font = [UIFont addHanSanSC:18.0 fontType:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.contentView.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentCarrier);
    }];
}

- (void)createChildVC{
    self.titles = @[
                    @"全部",
                    @"已参加",@"不参加",@"待确认"
                    ];
    
    self.childVC = [self setupChildVcAndTitle];
    [self addChildViewController:self.contentView];
    [self.contentCarrier addSubview:self.contentView.view];
}

- (NSArray *)setupChildVcAndTitle{
    NSMutableArray *childVcs = @[].mutableCopy;
     [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         HK_invitationListVC *childVC = [[HK_invitationListVC alloc] init];
         childVC.teaAboutInfoId = self.meetingid;
         childVC.InvitaStatus = idx;
         [childVcs addObject:childVC];
     }];
    return childVcs.copy;
}

#pragma mark -- TYPagerController
- (NSInteger)numberOfControllersInPagerController {
    return self.childVC.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return self.childVC[index];
}

#pragma mark - 继续邀请
- (IBAction)clickToInvite:(id)sender {
    AMMeetingBookingListViewController *bookingVC = [[AMMeetingBookingListViewController alloc] init];
    bookingVC.isEditMeeting = YES;
    bookingVC.teaAboutInfoId = self.meetingid;
    [self.navigationController pushViewController:bookingVC animated:YES];
}

- (void)loadData:(id _Nullable)sender {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"teaAboutInfoId"] = self.meetingid;
    
    [ApiUtil postWithParent:nil url:[ApiUtilHeader getMeetingInveteInfo] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            /// 继续邀请隐藏状态：1显示 2隐藏
            _canInvite = [[data objectForKey:@"hideState"] integerValue] %2;
            self.bottomView.hidden = !_canInvite;
            
            _currentCount = [[ToolUtil isEqualToNonNull:[data objectForKey:@"count"] replace:@"0"] integerValue];
            _meetingBeginDate = [ToolUtil isEqualToNonNullKong:[data objectForKey:@"teaStartTime"]];
            if (_currentCount == 0 || _meetingBeginDate.length == 0) {
                _topLabel.hidden = YES;
            }else {
                _topLabel.hidden = NO;
                NSString *countStr = [NSString stringWithFormat:@"%@人",@(_currentCount)];
                self.topLabel.text = [NSString stringWithFormat:@"%@开始的会客，共%@确定参加", _meetingBeginDate, countStr];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.topLabel.text];
                [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE22020) range:[self.topLabel.text rangeOfString:countStr]];
                self.topLabel.attributedText = attrStr;
            }
            
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {}];
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
