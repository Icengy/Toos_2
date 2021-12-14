//
//  ImproveDataViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/23.
//  Copyright © 2019年 lcy. All rights reserved.
//
// 完善认证资料
//

#import "ImproveDataViewController.h"

#import "ImproveDataACell.h"
#import "ImproveDataBCell.h"
#import "ImproveDataCCell.h"
#import "AMDialogView.h"
#import "AgreementTextView.h"

#import "ImproveConfirmedViewController.h"
#import "ArtsFieldViewController.h"
#import "SystemArticleViewController.h"

#import "IdentifyModel.h"

#import "UIViewController+BackButtonHandler.h"
#import "IdentifyViewController.h"

@interface ImproveDataViewController () <UITableViewDelegate ,UITableViewDataSource, ImproveDataBCellDelegate, ArtsFieldViewControllerDelegate, BackButtonHandlerProtocol>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmHeightConstraint;

@property (nonatomic ,assign) BOOL isSelectAgreement;
@property (nonatomic ,assign) BOOL isShowChangeDetail;

@property (nonatomic ,assign) CGFloat reasonLabelHeight;

@property (nonatomic ,assign) NSInteger improverType;//0 立即认证 1认证待审核 2已通过艺术家认证 3认证审核失败 4人脸识别失败

@end

@implementation ImproveDataViewController {
	IdentifyModel *_model;
	UserInfoModel *_userModel;
    CGFloat _improveDataBHeight;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    
	_isSelectAgreement = YES;
	
	_userModel = [UserInfoManager shareManager].model;
    
    _model = [[IdentifyModel alloc] init];
	
	_reasonLabelHeight = 0;
    _improveDataBHeight = 150.0f;
	
    _tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImproveDataACell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImproveDataACell class])];
	[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImproveDataBCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImproveDataBCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImproveDataCCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImproveDataCCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"填写认证资料"];
    
    //禁用右滑返回手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    if (![ToolUtil isEqualToNonNull:_model.ID]) {
        [self loadData:nil];
    }
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (_improverType) {
		return 3;
	}
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_improverType && indexPath.section == 0 && _isShowChangeDetail)
        return 44.0f+ _reasonLabelHeight;
    if ((_improverType && indexPath.section == 2) || (!_improverType && indexPath.section == 1))
        return _improveDataBHeight;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((_improverType && section == 1) || (!_improverType && section == 0)) return 44.0f;
    if (_improverType && section ==0) return 10.0f;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((_improverType && section == 1) || (!_improverType && section == 0)) {
        UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, 44.0f)];
        
        UILabel *label = [[UILabel alloc] init];
        [wrapView addSubview:label];
        
        label.font = [UIFont addHanSanSC:16.0f fontType:1];
        label.textColor = Color_Black;
        label.text = @"个人信息";
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wrapView.mas_left).offset(10.0f);
            make.top.bottom.right.equalTo(wrapView);
        }];
        return wrapView;
    }
    return [UIView new];

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [tableView numberOfSections] -1) return 44.0f;
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == [tableView numberOfSections] -1) {
        UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, ADBottomButtonHeight)];
        [self footerViewForCardData:wrapView];
        return wrapView;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 0) {
		if (_improverType)
			return [self ImproveDataCCell:tableView cellForRowAtIndexPath:indexPath];
		else
			return [self improveDataACell:tableView cellForRowAtIndexPath:indexPath];
	}else if (indexPath.section == 1) {
		if (_improverType)
			return [self improveDataACell:tableView cellForRowAtIndexPath:indexPath];
		else
			return [self ImproveDataBCell:tableView cellForRowAtIndexPath:indexPath];
	}else
		return [self ImproveDataBCell:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (_improverType && !indexPath.section) {
		_isShowChangeDetail = !_isShowChangeDetail;
		[tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	}
}

#pragma mark - ImproveDataBCellDelegate
- (void)cell:(ImproveDataBCell *)cell willDisplayCell:(CGFloat)contentSizeHeight {
    _improveDataBHeight = contentSizeHeight + 75.0f;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath)
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)cell:(ImproveDataBCell *)cell didSelectedToPickImages:(id)sender {
    [self clickToPickImages:sender];
}

- (void)cell:(ImproveDataBCell *)cell didSelectedToDeleteImage:(NSInteger)index {
    if (index >= _model.imgs.count) return;
    NSMutableArray *images = _model.imgs.mutableCopy;
    [images removeObjectAtIndex:index];
    _model.imgs = images.copy;
    
    cell.model = _model;
}

#pragma mark - ArtsFieldViewControllerDelegate
- (void)viewController:(BaseViewController *)viewController didSelectedArtField:(ArtsFieldModel *)fieldModel {
    NSLog(@"didSelectedArtField");
    _model.cateinfo = fieldModel;
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:_improverType?1:0]  withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark - BackButtonHandlerProtocol
- (BOOL)navigationShouldPopOnBackButton {
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[IdentifyViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
    
    return NO;
}

#pragma mark - UIView
- (ImproveDataACell *)improveDataACell:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ImproveDataACell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImproveDataACell class]) forIndexPath:indexPath];
	
    cell.model = _model;
	
	cell.editDataBlock = ^(NSString * _Nonnull input, NSInteger controlType) {
		NSLog(@"%@--%@",input, @(controlType));
		//controlType =0：真实姓名 =2：任职机构 =3：个人介绍
		switch (controlType) {
			case 0:
				_model.real_name = input;
				break;
            case 1: {
                [self.view endEditing:YES];
                ArtsFieldViewController *fieldVC = [[ArtsFieldViewController alloc] init];
                fieldVC.delegate = self;
                fieldVC.fieldModel = _model.cateinfo;
                fieldVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self.navigationController presentViewController:fieldVC animated:YES completion:nil];
                break;
            }
			case 2:
				_model.organization = input;
				break;
			case 3:
				_model.self_introduction = input;
				break;
				
			default:
				break;
		}
	};
	
	return cell;
}

- (ImproveDataBCell *)ImproveDataBCell:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ImproveDataBCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImproveDataBCell class]) forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    cell.delegate = self;
	cell.model = _model;
	
	return cell;
}

- (ImproveDataCCell *)ImproveDataCCell:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ImproveDataCCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImproveDataCCell class]) forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setContentHeight:_reasonLabelHeight reason:[ToolUtil isEqualToNonNullKong:_model.identexplain]];
	cell.isShowDetail = _isShowChangeDetail;
	
	return cell;
}

- (void)footerViewForCardData:(UIView *)wrapView {
	NSString *agreement = [NSString stringWithFormat:@"《%@认证服务协议》", AMBundleName];
	NSString *text = [NSString stringWithFormat:@"阅读并同意%@", agreement];
	
	AgreementTextView *textView = [[AgreementTextView alloc] initWithFrame:CGRectZero];
	[wrapView addSubview:textView];
	
	@weakify(self);
	[textView setAllText:text allFont:[UIFont addHanSanSC:14.0f fontType:1] allTextColor:Color_GreyLight linkText:agreement linkKey:nil linkFont:nil linkTextColor:RGB(219, 17, 17) block:^(NSString * _Nullable linkKey) {
		@strongify(self);
		dispatch_async(dispatch_get_main_queue(), ^{
			SystemArticleViewController *agreementVC = [[SystemArticleViewController alloc] init];
            /// 认证服务协议
			agreementVC.articleID = @"YSRMMTRZFWXY";
			agreementVC.needBottom = YES;
			agreementVC.completion = ^{
				_isSelectAgreement = YES;
				[self.tableView reloadData];
			};
			[self.navigationController pushViewController:agreementVC animated:YES];
		});
	}];
	
	CGFloat width = [text sizeWithFont:textView.font andMaxSize:CGSizeMake(CGFLOAT_MAX, textView.height)].width + ADAptationMargin;
	CGFloat height = [text sizeWithFont:[UIFont addHanSanSC:14.0f fontType:1] andMaxSize:CGSizeMake(wrapView.width, CGFLOAT_MAX)].height + 4.0f;
	[textView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(wrapView);
		make.width.offset(width);
		make.height.offset(height);
	}];
	
	AMButton *button = [AMButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, ADAptationMargin, ADAptationMargin);
	
	[button setImage:ImageNamed(@"select_no") forState:UIControlStateNormal];
	[button setImage:ImageNamed(@"select_yes") forState:UIControlStateSelected];
	
	button.selected = _isSelectAgreement;
	[button addTarget:self action:@selector(clickToAgreeAgreement:) forControlEvents:UIControlEventTouchUpInside];
	
	[wrapView addSubview:button];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(textView.mas_left);
		make.centerY.equalTo(textView);
		make.height.offset(button.height);
		make.width.offset(button.width);
	}];
}

#pragma mark -
- (void)clickToAgreeAgreement:(AMButton *)sender {
	sender.selected = !sender.selected;
	_isSelectAgreement = sender.selected;
}

- (IBAction)clickToConfirm:(AMButton *)sender {
	if (!_isSelectAgreement) {
		[SVProgressHUD showMsg:@"提交资料前须同意认证协议"];
		return;
	}
	if (![ToolUtil isEqualToNonNull:_model.real_name]) {
		[SVProgressHUD showMsg:@"请填写您的真实姓名"];
		return;
	}
    if (!_model.cateinfo) {
        [SVProgressHUD showMsg:@"请选择创作领域"];
        return;
    }

	
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"identify_type"] = @"2";
	params[@"real_name"] = _model.real_name;
	params[@"organization"] = _model.organization;
	params[@"self_introduction"] = _model.self_introduction;
    params[@"invitation_code"] = _model.invite_uid;
    params[@"pic"] = _model.imgs;
    params[@"arts"] = _model.cateinfo.id;
	
    [ApiUtil postWithParent:self url:[ApiUtilHeader addUserIdentify] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.navigationController pushViewController:[ImproveConfirmedViewController new] animated:YES];
    } fail:nil];
}

- (void)clickToPickImages:(id _Nullable)sender {
    AMImageSelectDialogView *dialogView = [AMImageSelectDialogView shareInstance];
    dialogView.title = @"选择图片";
    @weakify(dialogView);
    dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
        @strongify(dialogView);
        [dialogView hide];
        [self dialogSelectPhoto:meidaType];
    };
    [dialogView show];
}

- (void)dialogSelectPhoto:(AMImageSelectedMeidaType )meidaType {
    [ToolUtil showInController:self photoOfMax:9-_model.imgs.count withType:meidaType uploadType:5 completion:^(NSArray * _Nullable images) {
        NSMutableArray *imagesArray = _model.imgs.mutableCopy;
        [imagesArray addObjectsFromArray:images];
        _model.imgs = imagesArray.copy;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.tableView.numberOfSections - 1];
        ImproveDataBCell *cell = (ImproveDataBCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.model = _model;
	}];
}

#pragma mark -
- (void)loadData:(id)sender {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getIdentInfo] params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            _model = [IdentifyModel yy_modelWithDictionary:data];
            if ([UserInfoManager shareManager].isAuthed) {
                _model.real_name = [ToolUtil isEqualToNonNullKong:_userModel.auth_data.real_name];
            }
            _improverType  = [ToolUtil isEqualToNonNull:_model.identstatus replace:@"0"].integerValue;
            if (_model) {
                _reasonLabelHeight = [_model.identexplain sizeWithFont:[UIFont addHanSanSC:14.0f fontType:0] andMaxSize:CGSizeMake(K_Width - 60.0f, CGFLOAT_MAX)].height + ADAptationMargin;
            }
            [self.tableView reloadData];
        }
    } fail:nil];
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
