//
//  SearchResultListViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/12/16.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SearchResultListViewController.h"

#import "VideoPlayerViewController.h"
#import "AMBaseUserHomepageViewController.h"

#import "SearchResultCustomCell.h"
#import "SearchResultVideoCell.h"

#import "AMEmptyView.h"

#import "VideoListModel.h"

@interface SearchResultListViewController () <UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,weak) IBOutlet BaseTableView *layoutTV;
@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation SearchResultListViewController  {
	NSInteger _page;
    NSString *_urlStr;
    NSMutableDictionary *_params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.bgColorStyle = AMBaseBackgroundColorStyleGray;
	
	_dataArray = [NSMutableArray new];
	_page = 0;
    _urlStr = nil;
    _params = @{}.mutableCopy;
	
    _layoutTV.dataSource = self;
    _layoutTV.delegate = self;
    
    [_layoutTV registerNib:[UINib nibWithNibName:NSStringFromClass([SearchResultVideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SearchResultVideoCell class])];
    [_layoutTV registerNib:[UINib nibWithNibName:NSStringFromClass([SearchResultCustomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SearchResultCustomCell class])];
	
	[self.layoutTV addRefreshFooterWithTarget:self action:@selector(loadData:)];
	[self.layoutTV addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.layoutTV.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (!_dataArray.count)  [self loadData:nil];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_resultType == 0 && section == 0) return 10.0f;
	return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *wrapView = [UIView new];
    wrapView.backgroundColor = (_resultType == 0 && section == 0)?Color_Whiter:UIColor.clearColor;
	return wrapView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_resultType == 0) return 10.0f;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *wrapView = [UIView new];
    wrapView.backgroundColor = (_resultType == 0)?Color_Whiter:UIColor.clearColor;
    return wrapView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_resultType) {
		SearchResultCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchResultCustomCell class])];
		
		cell.model = _dataArray[indexPath.section];
		return cell;
	}else {
		SearchResultVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchResultVideoCell class])];
		
		cell.model = _dataArray[indexPath.section];
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (!_resultType) {
        
        VideoPlayerViewController *videoDetail = [[VideoPlayerViewController alloc] initWithStyle:(MyVideoShowStyleForList) videos:_dataArray.copy playIndex:indexPath.section listUrlStr:_urlStr params:_params];
		[self.navigationController pushViewController:videoDetail animated:YES];
	}else {
		NSLog(@"去个人简介");
		UserInfoModel *model = _dataArray[indexPath.section];
        AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
        vc.artuid = model.id;
        [self.navigationController pushViewController:vc animated:YES];
	}
}

#pragma mark -
- (void)setKeyword:(NSString *)keyword {
	_keyword = keyword;
	[self loadData:nil];
}

- (void)setResultType:(SearchResultType)resultType {
	_resultType = resultType;
}

//#pragma mark -
//- (UITableView *)layoutTV {
//	if (!_layoutTV) {
//		_layoutTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//
//		_layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
//		_layoutTV.backgroundColor = [UIColor clearColor];
//
//		_layoutTV.dataSource = self;
//		_layoutTV.delegate = self;
//
//		_layoutTV.tableFooterView = [UIView new];
//		_layoutTV.sectionFooterHeight = CGFLOAT_MIN;
//
//		[_layoutTV registerNib:[UINib nibWithNibName:NSStringFromClass([SearchResultVideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SearchResultVideoCell class])];
//		[_layoutTV registerNib:[UINib nibWithNibName:NSStringFromClass([SearchResultCustomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SearchResultCustomCell class])];
//	}return _layoutTV;
//}

#pragma mark -
- (void)loadData:(id)sender {
	if (![ToolUtil isEqualToNonNull:_keyword ]) {
		return;
	}
    self.layoutTV.allowsSelection = NO;
	if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
		[SVProgressHUD show];
	}
	if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
		_page ++;
	}else {
		_page = 0;
        if (_params.count) [_params removeAllObjects];
        if (_dataArray.count) [_dataArray removeAllObjects];
	}
	
	_urlStr = _resultType?[ApiUtilHeader getUserListSearch]:[ApiUtilHeader getVideoListSearch];
    
	_params[@"keyword"] = [ToolUtil isEqualToNonNullKong:_keyword];
	_params[@"page"] = StringWithFormat(@(_page));
    _params[@"uid"] = [UserInfoManager shareManager].uid;
	
    [ApiUtil postWithParent:self url:_urlStr needHUD:NO params:_params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.layoutTV endAllFreshing];
        NSArray *records;
        if (_resultType) { /// 用户
            records = (NSArray *)[response objectForKey:@"data"];
            if (records && records.count) {
                [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[UserInfoModel class] json:records]];
            }
        }else {
            NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
            if (data && data.count) {
                if (_page == 0) {
                    _params[@"timespan"] = [data objectForKey:@"timespan"];
                }
                
                records = (NSArray *)[data objectForKey:@"video"];
                if (records && records.count) {
                    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
                        if (_dataArray.count) [_dataArray removeAllObjects];
                    }
                    [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VideoListModel class] json:records]];
                }
            }
        }
        [self.layoutTV updataFreshFooter:(_dataArray.count && records.count != MaxListCount)];
        self.layoutTV.mj_footer.hidden = !_dataArray.count;
        [self.layoutTV ly_updataEmptyView:!_dataArray.count];
        [self.layoutTV reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.layoutTV endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
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
