//
//  PersonalDataEditViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/18.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PersonalDataEditViewController.h"

#import "PersonalDataModifyViewController.h"
#import "PhoneAuthViewController.h"
#import "FaceRecognitionViewController.h"

#import "AMDialogView.h"
#import "TOCropViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>

static int sumPhotos = 2;

@interface PersonalDataEditViewController ()  <UITableViewDelegate ,UITableViewDataSource, TOCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topCarrier;
@property (weak, nonatomic) IBOutlet AMIconImageView *headerIV;
@property (weak, nonatomic) IBOutlet AMButton *headerCoverIV;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UITableView *layoutTV;

@property (nonatomic ,strong) NSMutableArray *imagesArray;
@end

@implementation PersonalDataEditViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    [self.headerIV addBorderWidth:2.0f borderColor:UIColor.whiteColor];
	
	self.headerCoverIV.layer.borderWidth = 2.0f;
	self.headerCoverIV.layer.borderColor = Color_Whiter.CGColor;
	self.headerCoverIV.layer.cornerRadius = K_Width/8;
	self.headerCoverIV.clipsToBounds = YES;
	
	self.headerIV.contentMode = UIViewContentModeScaleAspectFill;
	
	self.headerLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	UserInfoModel *model = [UserInfoManager shareManager].model;
	if (model) {
		[self.headerIV am_setImageWithURL:model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
	}
	
	self.imagesArray = [NSMutableArray arrayWithCapacity:sumPhotos];
	
	self.layoutTV.delegate = self;
	self.layoutTV.dataSource = self;
	
	self.layoutTV.rowHeight = ADAPTATIONRATIOVALUE(100.0f);
	[self.layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.topCarrier.mas_bottom).offset(0);
		make.left.right.bottom.equalTo(self.view).offset(0);
	}];
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"个人资料"];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.layoutTV reloadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return ADAptationMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	cell.textLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
	cell.textLabel.textAlignment = NSTextAlignmentLeft;
	cell.textLabel.textColor = Color_Black;
    cell.detailTextLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.textColor = RGB(122,129,153);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"名字";
        cell.detailTextLabel.text = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.username];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"简介";
        cell.detailTextLabel.text = [ToolUtil isEqualToNonNullKong:[UserInfoManager shareManager].model.signature];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"实名认证";
        cell.detailTextLabel.text = [UserInfoManager shareManager].isAuthed?@"已认证":@"未认证";
    }
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        if ([UserInfoManager shareManager].isAuthed) {
            [self.navigationController pushViewController:[[PhoneAuthViewController alloc] init] animated:YES];
        }else {
            [self.navigationController pushViewController:[[FaceRecognitionViewController alloc] init] animated:YES];
//            AMAuthDialogView *dialogView = [AMAuthDialogView shareInstance];
//            @weakify(dialogView);
//            dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
//                @strongify(dialogView);
//                [dialogView hide];
//                if (meidaType) {
//                    [self.navigationController pushViewController:[[PhoneAuthViewController alloc] init] animated:YES];
//                }else {
//                    [self.navigationController pushViewController:[[FaceRecognitionViewController alloc] init] animated:YES];
//                }
//            };
//            [dialogView show];
        }
    }else {
        PersonalDataModifyViewController *modVC = [[PersonalDataModifyViewController alloc] init];
        modVC.modeifyType = indexPath.row;
        [self.navigationController pushViewController:modVC animated:YES];
    }
}

#pragma mark -
- (void)updateHeadImg:(NSArray *)imageUrls {
	NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"headimg"] = [ToolUtil isEqualToNonNullKong:imageUrls.lastObject];
	
    @weakify(self);
    [ApiUtil postWithParent:self url:[ApiUtilHeader editUserInfo] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:@"修改成功" completion:^{
            [[UserInfoManager shareManager] updateUserDataWithKey:@"headimg" value:imageUrls.lastObject complete:^(UserInfoModel * _Nullable model) {
                @strongify(self);
                [self.headerIV am_setImageWithURL:model.headimg placeholderImage:ImageNamed(@"logo") contentMode:UIViewContentModeScaleAspectFill];
            }];
        }];
    } fail:nil];
}

#pragma mark -
- (IBAction)changeHeaderIV:(id)sender {
	NSLog(@"更换头像");
    AMImageSelectDialogView *dialogView = [AMImageSelectDialogView shareInstance];
    dialogView.title = @"更换头像";
    dialogView.itemData = @[@"拍一张", @"从手机相册选择"];
    @weakify(dialogView);
    dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
        @strongify(dialogView);
        [dialogView hide];
        @weakify(self);
        [ToolUtil showInControllerWithoutUpload:self photoOfMax:1 withType:meidaType completion:^(NSArray * _Nullable images) {
            if (images.count > 0) {
                @strongify(self);
                UIImage *image = images.lastObject;
                dispatch_async(dispatch_get_main_queue(), ^{
                    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
                    cropController.delegate = self;
                    cropController.rotateButtonsHidden = YES;
                    [self presentViewController:cropController animated:YES completion:nil];
                });
            }
        }];
    };
    [dialogView show];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"图片上传中，请稍后..."];
    });
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        [self uploadImgs:@[image] uploadType:1];
    }];
}

#pragma mark -
- (void)uploadImgs:(NSArray *)imageArray uploadType:(NSInteger)uploadType {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"num"] = @"2";
    params[@"type"] = [NSString stringWithFormat:@"%@",@(uploadType)];
    [ApiUtil imagePost:[ApiUtilHeader uploadImage] params:params images:imageArray success:^(id response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([response[@"code"] integerValue]) {
                [SVProgressHUD showError:response[@"message"]];
            }else {
                NSArray *imageUrls = (NSArray *)response[@"data"];
                if (imageUrls && imageUrls.count) {
                    [SVProgressHUD showSuccess:response[@"message"]];
//                    if (completion) completion(imageUrls);
                    [self updateHeadImg:imageUrls];
                }else {
                    [SVProgressHUD showError:@"数据丢失，请重试"];
                }
            }
        });
    } fail:^(NSError *error) {
        [SVProgressHUD showError:showNetworkError];
    }];
}



@end
