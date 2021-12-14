//
//  FaceRecognitionViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/28.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "FaceRecognitionViewController.h"

#import <AuthSDK/AuthSDK.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "AVCaptureViewController.h"
#import "ImproveDataViewController.h"

#import "SingleInputTableCell.h"

@interface FaceRecognitionViewController () <UITableViewDelegate, UITableViewDataSource, SingleInputTableDelegate, AuthSDKDelegate>

@property (weak, nonatomic) IBOutlet AMButton *firstStep;
@property (weak, nonatomic) IBOutlet AMButton *secondStep;
@property (weak, nonatomic) IBOutlet AMButton *thirdStep;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *nextBtn;

@property (nonatomic ,assign) NSInteger currentStep;
@property (nonatomic ,copy) NSString *errorCode;
@property (nonatomic ,copy) NSString *errorReason;
@property (nonatomic ,copy) NSString *bizToken;

@property (nonatomic ,strong) AuthSDK *sdk;

@end

@implementation FaceRecognitionViewController {
    NSString *_realName, *_identifyCardID ,*_bizToken;
    NSArray *_titleArray, *_placeholderArray;
    BOOL _afterGetAuthResult;
}

- (AuthSDK *)sdk {
    if (!_sdk) {
        _sdk = [[AuthSDK alloc] initWithServerURL:@"https://faceid.qq.com"];
    }return _sdk;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    self.bgColorStyle = AMBaseBackgroundColorStyleDetault;
	_errorCode = 0;
    
    UIImage *normalImage = [UIImage imageWithColor:[RGB(112,115,128) colorWithAlphaComponent:0.1]];
    UIImage *selectedImage = [UIImage imageWithColor:[RGB(17,103,219) colorWithAlphaComponent:0.1]];
    
    [_firstStep setBackgroundImage:normalImage forState:UIControlStateNormal];
    [_secondStep setBackgroundImage:normalImage forState:UIControlStateNormal];
    [_thirdStep setBackgroundImage:normalImage forState:UIControlStateNormal];
    [_firstStep setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [_secondStep setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [_thirdStep setBackgroundImage:selectedImage forState:UIControlStateSelected];
	
	_firstStep.selected = YES;
	_secondStep.selected = NO;
	_thirdStep.selected = NO;
	
	self.currentStep = 0;
    
    _titleArray = @[@"真实姓名", @"身份证号码"];
    _placeholderArray = @[@"请填写真实姓名", @"请填写真实身份证号"];
    
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0f;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(55.0, 0.0, 0.0, 0.0);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SingleInputTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SingleInputTableCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"人脸识别认证"];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sections = _titleArray.count/2;
    if (section < sections) return 2;
    return _titleArray.count%2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleInputTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SingleInputTableCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.corners = indexPath.row%2?(UIRectCornerBottomLeft | UIRectCornerBottomRight):(UIRectCornerTopLeft | UIRectCornerTopRight);
    
    cell.canEdit = [UserInfoManager shareManager].model.is_auth.boolValue;
    cell.titleText = _titleArray[indexPath.section*2+indexPath.row];
    cell.placeholderText = _placeholderArray[indexPath.section*2+indexPath.row];
    cell.inputText = indexPath.row?_identifyCardID:_realName;
    cell.hideCodeBtn = YES;
    cell.keyboardType = indexPath.section?UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, 44.0f)];
    wrapView.backgroundColor = tableView.backgroundColor;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    [wrapView addSubview:headerLabel];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10.0f);
        make.centerY.equalTo(wrapView);
    }];
    
    headerLabel.textColor = RGB(21, 22, 26);
    headerLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    headerLabel.text = @"身份信息";
    
    AMButton *btn = [AMButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"拍摄身份证" forState:UIControlStateNormal];
    [btn setTitleColor:RGB(219,17,17) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(clickToPhotoCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [wrapView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(10.0f);
        make.centerY.equalTo(wrapView);
        make.height.equalTo(wrapView);
    }];
    btn.hidden = YES;
    
    return wrapView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SingleInputTableDelegate
- (void)cell:(SingleInputTableCell *)cell textDidChanged:(NSString *)newInputText {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row) _identifyCardID = newInputText;
    else _realName = newInputText;
}

#pragma mark-- AuthSDKDelegate
- (void)onResultBack:(NSDictionary *)result {
    NSLog(@"onResultBack ...%@",result);
    
    NSInteger identify_type = 2;
    if ([[result objectForKey:@"error"] integerValue]) {
        identify_type = 1;
        _firstStep.selected = YES;
        _secondStep.selected = NO;
        _thirdStep.selected = NO;
        self.tableView.hidden = NO;
        self.nextBtn.hidden = NO;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    //{"BizToken":"2C470CE4-9B0A-4D2C-B5B8-42AC9776CA0C","uid":"181","identify_type":"1"}
    params[@"BizToken"] = [ToolUtil isEqualToNonNullKong:_bizToken];
    params[@"identify_type"] = @(identify_type);
    params[@"uid"] = [UserInfoManager shareManager].uid;
    
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader posDetectInfo] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        @strongify(self);
        if (self.isFromArtistAuth) {
            [self goToImproveDataVC];
        }else
            [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark -
- (IBAction)clickToStep:(AMButton *)sender {
//	NSInteger tag = sender.tag - 8800;
//	self.currentStep = tag;
}

- (IBAction)clickToNext:(id)sender {
    if (![ToolUtil isEqualToNonNull:_realName]) {
        [SVProgressHUD showMsg:@"请填写您的真实姓名"];
        return;
    }
    if (![ToolUtil verifyIDCardString:_identifyCardID]) {
        [SVProgressHUD showMsg:@"请填写正确的身份证号码"];
        return;
    }
    
    NSDictionary *params = @{@"IdCard":_identifyCardID,@"Name":_realName};
    [ApiUtil postWithParent:self url:[ApiUtilHeader getDetectAuth] params:params success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *dict = (NSDictionary *)[response objectForKey:@"data"];
        if (dict && dict.count) {
            [self beginRecongnition:[dict objectForKey:@"BizToken"]];
        }else
            [SVProgressHUD showError:@"获取授权失败，请重试或联系客服"];
        
    } fail:nil];
}

- (void)clickToPhotoCard:(id)sender {
    AVCaptureViewController *AVCaptureVC = [[AVCaptureViewController alloc] init];
    [self.navigationController pushViewController:AVCaptureVC animated:YES];
}

#pragma mark -
- (void)goToImproveDataVC {
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"uid"] = [UserInfoManager shareManager].uid;
    
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUserInfo] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSDictionary *userData = (NSDictionary *)[data objectForKey:@"userData"];
            if (userData && userData.count) {
                UserInfoModel *model = [UserInfoModel yy_modelWithDictionary:userData];
                ///更新用户数据
                [[UserInfoManager shareManager] updateUserDataWithModel:model complete:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self.navigationController pushViewController:[[ImproveDataViewController alloc] init] animated:YES];
                });
            }
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.navigationController pushViewController:[[ImproveDataViewController alloc] init] animated:YES];
        });
    }];
}

- (void)beginRecongnition:(NSString *_Nullable)authString {
    _bizToken = authString;
    if (![ToolUtil isEqualToNonNull:_bizToken]) {
        [SVProgressHUD showMsg:@"校验失败，请重试或联系客服"];
        return;
    }
    
    _firstStep.selected = NO;
    _secondStep.selected = YES;
    _thirdStep.selected = NO;
    self.tableView.hidden = YES;
    self.nextBtn.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.sdk startAuthWithToken:_bizToken parent:self delegate:self];
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
