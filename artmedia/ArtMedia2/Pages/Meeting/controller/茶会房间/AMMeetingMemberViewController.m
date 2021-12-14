//
//  AMMeetingMemberViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingMemberViewController.h"

#import "AMMeetingMemberTableCell.h"

#import "LS_TRTCParams.h"

@interface AMMeetingMemberViewController () <UITableViewDelegate ,
UITableViewDataSource,
UIGestureRecognizerDelegate,
AMMeetingMemberTableCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AMMeetingMemberViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleClear;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
    [self.headerView borderForColor:UIColorFromRGB(0xE6E6E6) borderWidth:0.5f borderType:UIBorderSideTypeBottom];
    self.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    self.numLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    
    
    self.titleLabel.text = (self.style == AMMeetingMemberStyleManager)?@"会客管理":([ToolUtil isEqualToNonNull:self.params.ownerName]?[NSString stringWithFormat:@"%@的会客",self.params.ownerName]:@"会客管理");
    
    NSInteger num = self.totalMembers.count;
    NSString *numStr = [NSString stringWithFormat:@"当前人数：%@人",@(num)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:numStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE22020) range:[numStr rangeOfString:StringWithFormat(@(num))]];
    self.numLabel.attributedText = attrStr;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMMeetingMemberTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMMeetingMemberTableCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMeetingMemberTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMMeetingMemberTableCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.style = self.style;
    if (self.totalMembers && self.totalMembers.count) cell.roomModel = _totalMembers[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark - AMMeetingMemberTableCellDelegate
- (void)memberCell:(AMMeetingMemberTableCell *)memberCell didSelected:(AMButton *)sender onVideoWithUserID:(nonnull NSString *)userID {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(memberController:didSelected:onVideoWithModel:)]) {
        [self.delegate memberController:self didSelected:sender onVideoWithModel:memberCell.roomModel];
    }
}

- (void)memberCell:(AMMeetingMemberTableCell *)memberCell didSelected:(AMButton *)sender onAudioWithUserID:(nonnull NSString *)userID {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(memberController:didSelected:onAudioWithModel:)]) {
        [self.delegate memberController:self didSelected:sender onAudioWithModel:memberCell.roomModel];
    }
}

#pragma mark -
- (IBAction)clickToClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickToSwipe:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        [self clickToClose:gesture];
    }
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
