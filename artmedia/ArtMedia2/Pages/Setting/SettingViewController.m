//
//  SettingViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/16.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountSafeViewController.h"
#import "AboutUsViewController.h"
#import "Feedback_ViewController.h"

#import "BlacklistViewController.h"

#import "Setting_TableViewCell.h"
#import "CoreArchive.h"
#import "IMYWebView.h"

#import "MainTabBarController.h"
#import "AppDelegate.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView         * tableView;
@property (nonatomic ,strong) NSArray             * dataArray;

@end

@implementation SettingViewController {
    BOOL _isClickToLoginOut;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isClickToLoginOut = NO;
    
    self.dataArray = @[@[@"黑名单"], @[@"账号安全",@"意见反馈",@"清除缓存",@"关于我们"], @[@"联系客服"]];
	
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = @"设置";
}

#pragma mark -
-(UITableView*)tableView{
	if(!_tableView){
		_tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
		_tableView.showsVerticalScrollIndicator = NO;
		_tableView.showsHorizontalScrollIndicator = NO;
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.rowHeight = ADRowHeight;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		
		[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([Setting_TableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([Setting_TableViewCell class])];
	}
	return _tableView;
}

#pragma mark -
- (void)loginOutBtnClick {
    if (_isClickToLoginOut) return;
    [self loginout:nil];
}

- (void)loginout:(id)sender {
    @weakify(self);
    [SVProgressHUD showSuccess:@"退出登录成功" completion:^{
        @strongify(self);
        _isClickToLoginOut = YES;
        [self resetClientID];
        [[UserInfoManager shareManager] deleteUserData];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:NO];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([appDelegate.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
            MainTabBarController *tabVC = (MainTabBarController *)appDelegate.window.rootViewController;
            [tabVC setSelectedIndex:0];
        } else {
            MainTabBarController *tabVC = [[MainTabBarController alloc] init];
            [tabVC setSelectedIndex:0];
            appDelegate.window.rootViewController = [[MainTabBarController alloc] init];
        }
        
    }];
}

- (void)resetClientID {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"clientid"] = @"";
    params[@"device_type"] = @"0";
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader editUserInfo] params:params.copy success:^(NSInteger code, id  _Nullable response) {

    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {

    }];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _dataArray.count + 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section != _dataArray.count)
		return [_dataArray[section] count];
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return ADAptationMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, ADAptationMargin)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [UIView new];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == _dataArray.count) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
		}else
			[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		
		cell.textLabel.font = [UIFont addHanSanSC:17.0f fontType:0];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.textColor = Color_MainBg;
		cell.textLabel.text = @"退出登录";
		
		return cell;
	}else {
		Setting_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Setting_TableViewCell class]) forIndexPath:indexPath];
		if (!cell) {
			cell = [[Setting_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([Setting_TableViewCell class])];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.contentLabel.text = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
		cell.cashImage.hidden =  (indexPath.section == 1 && indexPath.row == 2) ? NO : YES;
		if (indexPath.section == 1 && indexPath.row == 2) {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.cashImage.text = [ToolUtil getCachesSize];
		}
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == _dataArray.count) {
		[self loginOutBtnClick];
	}else {
		if (![UserInfoManager shareManager].isLogin) {
			[self jumpToLoginWithBlock:nil];
			return;
		}
		if (indexPath.section == 0) {
			[self.navigationController pushViewController:[BlacklistViewController new] animated:YES];
		}else if (indexPath.section == 1) {
			switch (indexPath.row) {
				case 0:{
					[self.navigationController pushViewController:[AccountSafeViewController new] animated:YES];
				}
					break;
				case 1:{
					[self.navigationController pushViewController:[Feedback_ViewController new] animated:YES];
				}
					break;
				case 2:{
					Setting_TableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
					[self clearCache:cell.cashImage.text];
				}
					break;
				case 3:{
					[self.navigationController pushViewController:[AboutUsViewController new] animated:YES];
				}
					break;
					
				default:
					break;
			}
		}else {
			NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"057185311181"];
			IMYWebView * callWebview = [[IMYWebView alloc] init];
			[callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
			[self.view addSubview:callWebview];
		}
	}
}

#pragma mark -
/**
 清除缓存
 */
- (void)clearCache:(NSString *_Nullable)text {
	
	AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:[NSString stringWithFormat:@"当前缓存%@，是否清理？",text] buttonArray:@[@"立刻清理", @"暂不清理"] confirm:^{
		[ToolUtil removeCache:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
		}];
	} cancel:nil];
	[alertView show];
}
@end
