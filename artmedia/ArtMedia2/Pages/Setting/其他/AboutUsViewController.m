//
//  AboutUsViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/12/27.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "AboutUsViewController.h"

#import "SystemArticleViewController.h"

#import "AgreementTextView.h"

@interface AboutUsViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic ,strong) NSMutableArray <NSDictionary *>*dataArray;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"关于我们";
	
    _dataArray = [NSMutableArray arrayWithObjects:@{@"title":@"用户协议", @"id":@"YSRMTYHXY"},
                  @{@"title":@"隐私协议", @"id":@"RMRMTYSZC"},
                  @{@"title":@"认证服务协议", @"id":@"YSRMMTRZFWXY"},
                  @{@"title":@"视频上传用户协议", @"id":@"YSRMTSPSCYHXY"},
                  @{@"title":@"约见会客服务协议", @"id":@"YSRMTYJHKFWXY"},
                  nil];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@协议与条款", AMBundleName];
    _titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
	_versionLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
	_versionLabel.text = [NSString stringWithFormat:@"当前版本 V%@(%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
	
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionHeaderHeight = 0.0f;
    self.tableView.sectionFooterHeight = 0.0f;
	
    self.tableView.rowHeight = 44.0f;
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
	}else {
		[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	}
	cell.contentView.backgroundColor = Color_Whiter;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = RGB(17, 103, 219);
    cell.textLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
	
    NSString *agreementStr = [NSString stringWithFormat:@"《%@%@》", AMBundleName, [_dataArray[indexPath.row] objectForKey:@"title"]];
    cell.textLabel.text = agreementStr;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SystemArticleViewController *agreementVC = [[SystemArticleViewController alloc] init];
    agreementVC.articleID = [_dataArray[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //  隐藏每个分区最后一个cell的分割线
     if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
         // 1.系统分割线,移到屏幕外
         cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
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
