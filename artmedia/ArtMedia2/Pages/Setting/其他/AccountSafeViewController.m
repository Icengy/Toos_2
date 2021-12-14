//
//  AccountSafeViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/11/16.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "AccountSafeViewController.h"
#import "PasswordChange_ViewController.h"
#import "MobileChange_ViewController.h"
#import "MobileBind_ViewController.h"

#import "Setting_TableViewCell.h"

#import <WXApi.h>

@interface AccountSafeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView         * tableView;
@property (nonatomic ,strong) NSArray             * dataArray;

@end

@implementation AccountSafeViewController {
	UserInfoModel *_model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatBind:) name:WXAuthResult object:nil];
	
    self.dataArray = @[@"绑定手机号码",@"密码管理"];
	
	_model = [UserInfoManager shareManager].model;

    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.tableView reloadData];
	self.navigationItem.title = @"账号安全";
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([WXApi isWXAppInstalled]) {
		return 2;
	}
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section)
		return 1;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return section? ADDefaultButtonHeight:ADAptationMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section) {
		UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, ADDefaultButtonHeight)];
		wrapView.backgroundColor = Color_Whiter;
		
		UILabel *label = [[UILabel alloc] init];
		label.textColor = RGB(122,129,153);
		label.text = @"账号关联";
		label.font = [UIFont addHanSanSC:13.0f fontType:0];
		[wrapView addSubview:label];
		
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(wrapView);
			make.height.equalTo(wrapView);
			make.width.offset(wrapView.width - ADAptationMargin *2);
		}];
		
		return wrapView;
	}
	return [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, ADAptationMargin)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return section?CGFLOAT_MIN:ADAptationMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [UIView new];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
	}else
		[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if (indexPath.section) {
        cell.accessoryType = UITableViewCellAccessoryNone;
		[cell.contentView addSubview:[self createWeChatBindView]];
	}else {
		cell.textLabel.text = self.dataArray[indexPath.row];
		cell.textLabel.font = [UIFont addHanSanSC:16.0f fontType:1];
		cell.textLabel.textColor = Color_Black;
		
		NSString *account = [ToolUtil isEqualToNonNullKong:_model.mobile];
		cell.detailTextLabel.text = indexPath.row?([ToolUtil isEqualToNonNull:_model.password ]?@"修改":@"设置"):[ToolUtil getSecretMobileNumWitMobileNum:account];
		cell.detailTextLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
		cell.detailTextLabel.textColor = RGB(122,129,153);
		cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section) {
		if ([WXApi isWXAppInstalled]) {
			if (_model.is_bind_wechat) {
				AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"当前账户已绑定微信，继续会解绑该微信。是否继续？" buttonArray:@[@"继续", @"取消"] confirm:^{
                    [self wechatOption:nil type:1];
				} cancel:nil];
				[alert show];
			}else {
				SendAuthReq *req = [[SendAuthReq alloc] init];
				req.scope = @"snsapi_userinfo";
				req.state = @"App";
                [WXApi sendReq:req completion:^(BOOL success) {
                    NSLog(@"%d",success);
                }];
			}
		}else {
			AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"未检测到微信应用或版本过低" buttonArray:@[@"确定"] confirm:nil cancel:nil];
			[alertView show];
		}
	}else {
		switch (indexPath.row) {
			case 0:{
				[self.navigationController pushViewController:[MobileBind_ViewController new] animated:YES];
			}
				break;
			case 1:{
				PasswordChange_ViewController *passwChangeVC = [[PasswordChange_ViewController alloc] init];
				passwChangeVC.type = 0;
				[self.navigationController pushViewController:passwChangeVC animated:YES];
			}
				break;
				
			default:
				break;
		}
	}
}
#pragma mark -
- (void)weChatBind:(NSNotification *)noti {
    [self wechatOption:(NSDictionary *)noti.userInfo type:0];
}

/// 微信绑定与解绑
/// @param userInfo 用户微信信息（解绑情况为空）
/// @param type 0:绑定 1:解绑
- (void)wechatOption:(NSDictionary *)userInfo type:(NSInteger)type {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    if (!type) {
        params[@"wechatid"] = [ToolUtil isEqualToNonNullKong:[userInfo objectForKey:@"openid"]];
        params[@"openid"] = [ToolUtil isEqualToNonNullKong:[userInfo objectForKey:@"unionid"]];
    }else {
        params[@"wechatid"] = @"";
        params[@"openid"] = @"";
    }
    
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader b_wechat] params:params.copy success:^(NSInteger code, id  _Nullable response) {

        SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
        alertView.canTouchBlank = NO;
        alertView.title = [ToolUtil isEqualToNonNull:[response objectForKey:@"message"] replace:@"操作成功!"];
        alertView.confirmBlock = ^{
            _model.is_bind_wechat = !_model.is_bind_wechat;
            _model.wechatid =  type?@"":[params objectForKey:@"openid"];
            [[UserInfoManager shareManager] updateUserDataWithModel:_model complete:^(UserInfoModel * _Nullable model) {
                @strongify(self);
                _model = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        };
        [alertView show];
    } fail:nil];
}

#pragma mark -
- (UIView *)createWeChatBindView {
	UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, ADRowHeight)];
	
	UIImageView *iconIV = [[UIImageView alloc] initWithImage:ImageNamed(@"wechat_icon01")];
	[wrapView addSubview:iconIV];
	[iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(wrapView.mas_left).offset(ADAptationMargin);
		make.height.width.offset(wrapView.height*3/4);
		make.centerY.equalTo(wrapView);
	}];
	
	UILabel *detailTextLabel = [[UILabel alloc] init];
	[wrapView addSubview:detailTextLabel];
	[detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(wrapView.mas_right).offset(-ADAptationMargin *2);
		make.centerY.equalTo(wrapView);
		make.height.equalTo(wrapView);
	}];
	
	detailTextLabel.text = _model.is_bind_wechat?@"已绑定":@"未绑定";
	detailTextLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
	detailTextLabel.textColor = RGB(122,129,153);
	detailTextLabel.textAlignment = NSTextAlignmentRight;
	[detailTextLabel sizeToFit];
	
	UILabel *textLabel = [[UILabel alloc] init];
	[wrapView addSubview:textLabel];
	[textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(detailTextLabel.mas_left);
		make.height.centerY.equalTo(detailTextLabel);
		make.left.equalTo(iconIV.mas_right).offset(ADAptationMargin);
	}];
	textLabel.text = @"微信";
	textLabel.font = [UIFont addHanSanSC:16.0f fontType:1];
	textLabel.textColor = Color_Black;
	textLabel.textAlignment = NSTextAlignmentLeft;
	
	return wrapView;
}
#pragma mark -
-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = ADRowHeight;

    }
    return _tableView;
}


@end
