//
//  AMNewArtistMainSubViewController.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistMainSubViewController.h"
#import "VideoPlayerViewController.h"
#import "WebViewURLViewController.h"

#import "AMNewArtistMainHeadView.h"

#import "AMNewArtistMainTimeLineCell.h"
#import "AMNewArtistMainTimeLineNoDataCell.h"
#import "AMNewArtistMainTextCell.h"
#import "AMNewArtistMainVideoCell.h"

#import "CustomPersonalModel.h"

@interface AMNewArtistMainSubViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@end

@implementation AMNewArtistMainSubViewController {
    NSMutableArray <AMNewArtistTimeLineModel *>*_dataArray;
}

- (void)setUserModel:(CustomPersonalModel *)userModel{
    _userModel = userModel;
    
    if (_dataArray.count) [_dataArray removeAllObjects];
    [_userModel.meetingData enumerateObjectsUsingBlock:^(AMNewArtistTimeLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_dataArray insertObject:obj atIndex:_dataArray.count];
        
        if (idx > 2) *stop = YES;
    }];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[].mutableCopy;
    
    [self setUpTableView];
}

- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, SafeAreaBottomHeight, 0.0f);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainHeadView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([AMNewArtistMainHeadView class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainTimeLineCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMNewArtistMainTimeLineCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainTimeLineNoDataCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMNewArtistMainTimeLineNoDataCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainTextCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMNewArtistMainTextCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMNewArtistMainVideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMNewArtistMainVideoCell class])];
    
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

- (UIScrollView *)scrollView {
    return self.tableView;
}

#pragma mark -- UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemListController:scrollToTopOffset:)])
            [self.delegate itemListController:self scrollToTopOffset:YES];
    }
    self.tableView.showsVerticalScrollIndicator = self.vcCanScroll;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AMNewArtistMainHeadView * head = [AMNewArtistMainHeadView share];
    head.frame = CGRectMake(0, 0, tableView.width, 44.0f);
    @weakify(self);
    head.moreVideoClickBlock = ^{
        @strongify(self);
        if (self.clickForMoreVideosBlock) self.clickForMoreVideosBlock();
    };
    head.moreInfoClickBlock = ^{
        @strongify(self);
        [self clickToMoreInfo];
    };
    
    if (section == 0) {
        head.headLabel.text = @"近期会客";
        
        head.moreVideoButton.hidden = YES;
        head.meetNumberLabel.hidden = YES;
        head.timeLabel.hidden = NO;

        head.moreInfoButton.hidden = YES;
        

        if ([ToolUtil isEqualToNonNull:self.userModel.userData.last_sync_date]) {
            NSLog(@"_model.userData.last_sync_date = %@",[TimeTool timestampToTime:self.userModel.userData.last_sync_date.doubleValue withFormat:AMDataFormatter]);
            head.timeLabel.hidden = NO;
            NSString *activeStatusStr = [TimeTool getTimeFromPassTimeIntervalToNowTimeInterval:self.userModel.userData.last_sync_date.integerValue];
            if ([activeStatusStr containsString:@"秒"]) {
                head.timeLabel.text = @"刚刚";
            }else
                head.timeLabel.text = [NSString stringWithFormat:@"%@前活跃",activeStatusStr];
        }else {
            head.timeLabel.hidden = YES;
        }
    }else if(section == 1) {
        head.headLabel.text = @"个人简介";
        
        head.moreVideoButton.hidden = YES;
        head.meetNumberLabel.hidden = YES;
        head.timeLabel.hidden = YES;
        head.moreInfoButton.hidden = !self.userModel.userData.if_has_introduce.boolValue;
        
    }else {
        head.headLabel.text = @"最热视频";
        
        head.meetNumberLabel.hidden = YES;
        head.moreVideoButton.hidden = NO;
        head.timeLabel.hidden = YES;
        head.moreInfoButton.hidden = YES;
    }
    head.stackBackView.hidden = (head.meetNumberLabel.hidden && head.moreVideoButton.hidden && head.timeLabel.hidden && head.moreInfoButton.hidden);
    return head;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (self.userModel.videoData && self.userModel.videoData.count)?3:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_dataArray.count) return _dataArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_dataArray.count) {
            AMNewArtistMainTimeLineCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMNewArtistMainTimeLineCell class]) forIndexPath:indexPath];
            
            if (_dataArray.count) cell.model = [_dataArray objectAtIndex:indexPath.row];
            
            if (indexPath.row == 0) {
                if (_dataArray.count == 1) {
                    cell.linePosition = -2;
                }else
                    cell.linePosition = -1;
            }else if (indexPath.row == (_dataArray.count - 1)) {
                cell.linePosition = 1;
            }else
                cell.linePosition = 0;
            
            return cell;
        }else {
            AMNewArtistMainTimeLineNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMNewArtistMainTimeLineNoDataCell class]) forIndexPath:indexPath];
            return cell;
        }

    }else if (indexPath.section == 1) {
        AMNewArtistMainTextCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMNewArtistMainTextCell class]) forIndexPath:indexPath];
        
        cell.signatureLabel.text = [ToolUtil isEqualToNonNull:self.userModel.userData.signature replace:@"暂无简介"];
        return cell;
    }else if (indexPath.section == 2) {
        
        AMNewArtistMainVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMNewArtistMainVideoCell class]) forIndexPath:indexPath];
        cell.data = self.userModel.videoData.mutableCopy;
        @weakify(self);
        cell.videoPlayBlock = ^(VideoListModel * _Nonnull model) {
            @strongify(self);
            VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithStyle:(MyVideoShowStyleForList) videos:self.userModel.videoData playIndex:[self.userModel.videoData indexOfObject:model] listUrlStr:nil params:nil];
            [self.navigationController pushViewController:videoDetail animated:YES];
        };
        return cell;
    }else{
        return nil;
    }
}

#pragma mark -
- (void)clickToMoreInfo {
    WebViewURLViewController *webView = [[WebViewURLViewController alloc] initWithUrlString:[ApiUtil_H5Header h5_showMoreInfo:[ToolUtil isEqualToNonNull:self.userModel.userData.id replace:@"0"]]];
    webView.navigationBarTitle = self.userModel.userData.username;
    [self.navigationController pushViewController:webView animated:YES];
}

@end
