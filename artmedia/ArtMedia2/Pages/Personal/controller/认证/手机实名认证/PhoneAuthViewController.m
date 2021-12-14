//
//  PhoneAuthViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PhoneAuthViewController.h"

#import "AVCaptureViewController.h"

#import "PersonalRealNameAuthView.h"
#import "SingleInputTableCell.h"
#import "ImproveDataViewController.h"

@interface PhoneAuthViewController () <PersonalRealNameAuthDelegate, UITableViewDelegate ,UITableViewDataSource, SingleInputTableDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@property(nonatomic,strong) NSTimer*timer;
@end

@implementation PhoneAuthViewController {
    NSString *_realName, *_identifyCardID, *_phone, *_code;
    NSArray *_titleArray, *_placeholderArray;
    NSMutableArray <NSString *>*_inputTextArray;
    NSInteger _num;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }return _timer;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _num = 60;
    
    self.confirmBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
    
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0f;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SingleInputTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SingleInputTableCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self loadData:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"实名认证";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCardInfo:) name:@"AfterGetUserCardInfo" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
        _num = 60;
    }
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
    cell.inputText = _inputTextArray[indexPath.section*2+indexPath.row];
    cell.hideCodeBtn = YES;
    if (indexPath.section && indexPath.row) {
        cell.hideCodeBtn = NO;
        cell.timerCount = _num;
    }
    cell.keyboardType = indexPath.section?UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([UserInfoManager shareManager].model.is_auth.boolValue)  return 15.0f;
    if (section && ![ToolUtil isEqualToNonNull:_realName]) return 15.0f;
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([UserInfoManager shareManager].model.is_auth.boolValue)  return [UIView new];
    if (section && ![ToolUtil isEqualToNonNull:_realName]) return [UIView new];
        
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, 44.0f)];
    wrapView.backgroundColor = tableView.backgroundColor;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    [wrapView addSubview:headerLabel];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10.0f);
        make.right.offset(-10.0f);
        make.height.centerY.equalTo(wrapView);
    }];
    
    if (section) {
        headerLabel.textColor = RGB(153, 153, 153);
        headerLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
        headerLabel.text = [NSString stringWithFormat:@"请确保是“%@”实名办理的手机号",_realName];
    }else {
        headerLabel.textColor = RGB(21, 22, 26);
        headerLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
        headerLabel.text = @"使用手机号码进行实名认证";
        
        AMButton *btn = [AMButton buttonWithType:UIButtonTypeCustom];
          
          [btn setTitle:@"拍摄身份证" forState:UIControlStateNormal];
          [btn setTitleColor:RGB(219,17,17) forState:UIControlStateNormal];
          btn.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
          [btn sizeToFit];
          [btn addTarget:self action:@selector(clickToPhotoCard:) forControlEvents:UIControlEventTouchUpInside];
          
          [wrapView addSubview:btn];
          [btn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.right.offset(-15.0f);
              make.height.centerY.equalTo(wrapView);
          }];
    }
    
    return wrapView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SingleInputTableDelegate
- (void)cell:(SingleInputTableCell *)cell textDidChanged:(NSString *)newInputText {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ((indexPath.section*2+indexPath.row) >= _inputTextArray.count) return;
    
    [_inputTextArray replaceObjectAtIndex:(indexPath.section*2+indexPath.row) withObject:newInputText];
    [_inputTextArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) _realName = obj;
        if (idx == 1) _identifyCardID = obj;
        if (idx == 2) _phone = obj;
        if (idx == 3) _code = obj;
    }];
    if (!indexPath.section && !indexPath.row && [self.tableView numberOfSections] > 1) {
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];
    }
}

- (void)cell:(SingleInputTableCell *)cell didSelectedCodeBtn:(id)sender {
    if (![ToolUtil valifyMobile:_phone]) {
        [SVProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"6";
    params[@"mobile"] = _phone;

    [ApiUtil postWithParent:self url:[ApiUtilHeader getVerificationCode] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:response[@"message"]];
        [self.timer setFireDate:[NSDate distantPast]];
    } fail:nil];
}

#pragma mark -
- (void)clickToPhotoCard:(id)sender {
    [self.navigationController pushViewController:[[AVCaptureViewController alloc] init] animated:YES];
}

- (IBAction)clickToConfirm:(id)sender {
    if (![ToolUtil isEqualToNonNull:_realName]) {
        [SVProgressHUD showError:@"请输入真实姓名"];
        return;
    }
    if (![ToolUtil verifyIDCardString:_identifyCardID]) {
        [SVProgressHUD showError:@"请输入正确的身份证号码"];
        return;
    }
    if (![ToolUtil valifyMobile:_phone]) {
        [SVProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (![ToolUtil isEqualToNonNull:_code]) {
        [SVProgressHUD showError:@"请输入验证码"];
        return;
    }
    NSMutableDictionary *verifyCodeParams = @{}.mutableCopy;
    verifyCodeParams[@"type"] = @"6";
    verifyCodeParams[@"mobile"] = _phone;
    verifyCodeParams[@"code"] = _code;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader verifyCode] params:verifyCodeParams.copy success:^(NSInteger code, id  _Nullable response) {
        //FaceId/check_IDcard
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"uid"] = [UserInfoManager shareManager].uid;
        params[@"uname"] = _realName;
        params[@"cardid"] = _identifyCardID;
        params[@"mobile"] = _phone;
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader checkIDcard] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            SingleAMAlertView *alert  = [SingleAMAlertView shareInstance];
            alert.title = @"实名认证申请提交成功";
            alert.canTouchBlank = NO;
            alert.confirmBlock = ^{
                if (_isFromArtistAuth) {
                    [self.navigationController pushViewController:[[ImproveDataViewController alloc] init] animated:YES];
                }else
                    [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [alert show];
        } fail:nil];
    } fail:nil];
}

#pragma mark - prvite
- (void)countDown {
    if (_num < 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    SingleInputTableCell *cell = (SingleInputTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.timerCount = _num;
    _num --;
}

- (void)getCardInfo:(NSNotification *)noti {
    NSLog(@"getCardInfo = %@",noti.object);
    _realName = noti.object[@"name"];
    _identifyCardID = noti.object[@"num"];
    
    [_inputTextArray replaceObjectAtIndex:0 withObject:_realName];
    [_inputTextArray replaceObjectAtIndex:1 withObject:_identifyCardID];
    
    [self.tableView reloadData];
}

- (void)loadData:(id)sender {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUserIdentInfo] params:@{@"uid":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        
        self.confirmBtn.hidden = YES;
        self.bgColorStyle = AMBaseBackgroundColorStyleGray;

        _titleArray = @[@"真实姓名", @"身份证号码"];
        _placeholderArray = @[@"请填写真实姓名", @"请填写真实身份证号"];
        NSDictionary *data = [response objectForKey:@"data"];
        if (data) {
            _realName = [ToolUtil isEqualToNonNull:[data objectForKey:@"real_name"] replace:@"数据错误，请重试"];
            _identifyCardID = [ToolUtil isEqualToNonNull:[data objectForKey:@"id_card_number"] replace:@"数据错误，请重试"];
        }
        
        [self fillForm];
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (errorCode == -1) {
            self.confirmBtn.hidden = NO;
            self.bgColorStyle = AMBaseBackgroundColorStyleDetault;
            
            _titleArray = @[@"真实姓名", @"身份证号码", @"手机号", @"验证码"];
            _placeholderArray = @[@"请填写真实姓名", @"请填写真实身份证号", @"请输入手机号码", @"请输入验证码"];
            
            [self fillForm];
        }else {
            [SVProgressHUD showMsg:errorMsg completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)fillForm {
    _inputTextArray = @[].mutableCopy;
    [_titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [_inputTextArray insertObject:[ToolUtil isEqualToNonNull:_realName replace:[NSString new]] atIndex:_inputTextArray.count];
        }else if (idx == 1) {
            [_inputTextArray insertObject:[ToolUtil isEqualToNonNull:_identifyCardID replace:[NSString new]] atIndex:_inputTextArray.count];
        }else
            [_inputTextArray insertObject:[NSString new] atIndex:_inputTextArray.count];
    }];
    
    [self.tableView reloadData];
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
