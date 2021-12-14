//
//  AddAdressViewController.m
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/28.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "AddAdressViewController.h"

#import <BRPickerView.h>

#import "CommitTableViewCell.h"

#define kAddressDefaultHeight 55.0f

@interface AddAdressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet BaseTableView *tableView;
@property (nonatomic, weak) IBOutlet AMButton *finishBtn;
@property (nonatomic ,strong) BRAddressPickerView *addressPickView;

@end

@implementation AddAdressViewController
{
    BOOL _isShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_finishBtn setTitle:(_type == 1)?@"确定添加":@"确定修改" forState:UIControlStateNormal];
    _finishBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    
    if (!self.addressModel) self.addressModel = [MyAddressModel new];
    
    _tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommitTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CommitTableViewCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = _type?@"添加地址":@"编辑地址";
}

- (BRAddressPickerView *)addressPickView {
	if (!_addressPickView) {
		_addressPickView = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeArea];
		_addressPickView.title = @"请选择所在地区";
		@weakify(self);
		_addressPickView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            @strongify(self);
            self.addressModel.addrregion = [NSString stringWithFormat:@"%@ %@ %@",province.name, city.name, area.name];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
			});
		};
	}return _addressPickView;
}

#pragma mark - UITableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section?0:4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section || (indexPath.section == 0 && indexPath.row == 2)) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
		}else
			[cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		cell.selectionStyle = 0;
		
		if (!indexPath.section) {
			UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0, 80.0f, kAddressDefaultHeight)];
			nameLabel.textColor = Color_Black;
			nameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
			[cell.contentView addSubview:nameLabel];
			
			if (indexPath.row == 2) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
				nameLabel.text = @"所在地区:";
				UILabel *addressLabel = [[UILabel alloc] init];
				[cell.contentView addSubview:addressLabel];
				
				addressLabel.numberOfLines = 0;
				addressLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
				if ([ToolUtil isEqualToNonNull:self.addressModel.addrregion]) {
					addressLabel.text = [ToolUtil isEqualToNonNullKong:self.addressModel.addrregion];
					addressLabel.textColor = Color_Black;
				}else {
					addressLabel.text = @"点击选择所在地区";
					addressLabel.textColor = Color_Grey;
				}
				[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
					make.left.equalTo(nameLabel.mas_right).offset(8.0f);
					make.centerY.height.equalTo(nameLabel);
					make.right.equalTo(cell.contentView.mas_right).offset(-8.0f);
				}];
				
			}else if (indexPath.row == 3) {

				nameLabel.text = @"详细地址:";
				
				UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width+8.0f, nameLabel.y, cell.contentView.width-(nameLabel.y+nameLabel.width+8.0f) -8.0f, kAddressDefaultHeight*2-8.0f)];
				textView.placeholder = @"请输入详细地址";
				textView.font = [UIFont addHanSanSC:15.0f fontType:0];
				textView.text = self.addressModel.address;
				[cell.contentView addSubview:textView];
			}
		}
		
		return cell;
	}
	@weakify(self);
    CommitTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommitTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = 0;
    
	switch (indexPath.row) {
		case 0: {
			cell.nameLabel.text = @"收货人:";
			cell.textFiled.placeholder = @"请输入收货人姓名";
			cell.textFiledBlock = ^(NSString * _Nonnull text) {
				@strongify(self);
                self.addressModel.reciver = text;
			};
			cell.textFiled.text = [ToolUtil isEqualToNonNullKong:self.addressModel.reciver];
		}
			break;
		case 1: {
			cell.nameLabel.text = @"联系电话:";
			cell.textFiled.placeholder = @"请输入收货人联系电话";
			cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
			cell.textFiledBlock = ^(NSString * _Nonnull text) {
				@strongify(self);
				self.addressModel.phone = text;
			};
			cell.textFiled.text = [ToolUtil isEqualToNonNullKong:self.addressModel.phone];
		}
			break;
		case 2: {
			cell.nameLabel.text = @"所在地区:";
			cell.textFiled.placeholder = @"点击选择所在地区";
			cell.textFiled.userInteractionEnabled = NO;
			cell.textFiled.text = [ToolUtil isEqualToNonNullKong:self.addressModel.addrregion];
			[cell.textFiled sizeToFit];
		}
			break;
		case 3: {
			cell.nameLabel.text = @"详细地址:";
			cell.textFiled.placeholder = @"请输入详细地址";
			cell.textFiledBlock = ^(NSString * _Nonnull text) {
				@strongify(self);
                self.addressModel.address = text;
			};
			cell.textFiled.text = [ToolUtil isEqualToNonNullKong:self.addressModel.address];
		}
			break;
	
		default:
			break;
	}
   
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (!section) {
		return [UIView new];
	}
	UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, kAddressDefaultHeight)];
	wrapView.backgroundColor = Color_Whiter;
	
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0, wrapView.width/3, wrapView.height)];
	[wrapView addSubview:nameLabel];
	
	nameLabel.text = @"设为默认地址";
	nameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
	nameLabel.textColor = Color_Black;
	
	AMButton *switchBtn = [AMButton buttonWithType:UIButtonTypeCustom];
	switchBtn.frame = CGRectMake(0, 0, (wrapView.height*2/3)*2, wrapView.height*2/3);
	[wrapView addSubview:switchBtn];
	switchBtn.contentHorizontalAlignment = NSTextAlignmentRight;
	
	[switchBtn setImage:ImageNamed(@"switch_close") forState:UIControlStateNormal];
	[switchBtn setImage:ImageNamed(@"switch_open") forState:UIControlStateSelected];;
	
	switchBtn.selected = self.addressModel.is_default;
	[switchBtn addTarget:self action:@selector(clickToDefault:) forControlEvents:UIControlEventTouchUpInside];
	
	[switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(wrapView.mas_right).offset(-15.0f);
		make.centerY.equalTo(wrapView);
		make.width.offset(switchBtn.width);
		make.height.offset(switchBtn.height);
	}];
	
	return wrapView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.section?CGFLOAT_MIN:kAddressDefaultHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return section?kAddressDefaultHeight:0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return section? ADAptationMargin:CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!indexPath.section && indexPath.row == 2) {
		if ([ToolUtil isEqualToNonNull:self.addressModel.addrregion]) {
			NSArray *addressArray = [self.addressModel.addrregion componentsSeparatedByString:@" "];
			if (addressArray && addressArray.count == 3) {
				self.addressPickView.selectValues = addressArray;
			}
		}
		[self.addressPickView show];
    }
}

#pragma mark -
-(IBAction)editAddress:(id)sender {
    if(self.addressModel.addrregion.length==0 ||
       self.addressModel.reciver.length==0 ||
       self.addressModel.phone.length==0 ||
       self.addressModel.address.length==0 ||
	   [[self.addressModel.addrregion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ||
	   [[self.addressModel.reciver stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] ==0||
	   [[self.addressModel.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] ==0||
	   [[self.addressModel.address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] ==0) {
		[SVProgressHUD showMsg:@"请先完善信息！"];
        return;
    }
    NSMutableDictionary*address = [NSMutableDictionary dictionary];
    if(self.addressModel.ID.length!=0) {
        _type = 2;
    }else{
        _type = 1;
    }
    if(_type != 1) {
        [address setObject:[ToolUtil isEqualToNonNullKong:self.addressModel.ID] forKey:@"id"];
    }
    [address setObject:[UserInfoManager shareManager].uid forKey:@"uid"];
    [address setObject:[ToolUtil isEqualToNonNullKong:self.addressModel.reciver] forKey:@"reciver"];
    [address setObject:[ToolUtil isEqualToNonNullKong:self.addressModel.phone] forKey:@"phone"];
    [address setObject:[ToolUtil isEqualToNonNullKong:self.addressModel.addrregion] forKey:@"addrregion"];
    [address setObject:[ToolUtil isEqualToNonNullKong:self.addressModel.address] forKey:@"address"];
    [address setObject:[NSString stringWithFormat:@"%@",@(self.addressModel.is_default)] forKey:@"is_default"];
    
    NSMutableDictionary*dic = [NSMutableDictionary dictionary];
    [dic setObject:@(_type) forKey:@"type"];
    [dic setObject:address forKey:@"address"];
	
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader editUserAddress] params:dic.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:response[@"message"] completion:^{
            @strongify(self);
            if (self.clickToNewAddress) self.clickToNewAddress(self.addressModel);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } fail:nil];
}

- (void)clickToDefault:(AMButton *)sender {
	sender.selected = !sender.selected;
    self.addressModel.is_default = sender.selected;
}



@end
