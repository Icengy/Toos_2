//
//  PublishVideoViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/24.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PublishVideoViewController.h"

#import <UGCKit/UGCKit.h>
#import <TXLiteAVSDK.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "TXUGCPublish.h"

#import "UIViewController+BackButtonHandler.h"
#import "UIImage+CropRotate.h"

#import "SystemArticleViewController.h"
#import "IdentifyViewController.h"
#import "GoodsClassViewController.h"
#import "CZHChooseCoverController.h"
#import "PublishResultViewController.h"
#import "FaceRecognitionViewController.h"

#import "PublishVideoCell.h"
#import "PublishGoodsCell.h"
#import "ImproveDataCCell.h"
#import "GoodsSellTableCell.h"
#import "PublishGenerateLeadingView.h"

#import "AgreementTextView.h"

#import "AMDialogView.h"
#import <BRPickerView/BRPickerView.h>

#import "VideoListModel.h"
#import "VideoGoodsImageModel.h"


@interface GoodsSwitch : UISwitch

@end

@implementation GoodsSwitch

- (void)awakeFromNib {
	[super awakeFromNib];
	self.onImage = ImageNamed(@"switch_open");
	self.offImage = ImageNamed(@"switch_close");
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.onImage = ImageNamed(@"switch_open");
		self.offImage = ImageNamed(@"switch_close");
	}return self;
}

@end

@interface PublishVideoViewController () <UINavigationBarDelegate, UITableViewDelegate ,UITableViewDataSource, PublishGoodsCellDelegate, GoodsClassDelegate, PublishVideoCellDelegate, GoodsSellTableCellDelegate, TXVideoGenerateListener, TXVideoPublishListener>

@property (weak, nonatomic) IBOutlet PublishGenerateLeadingView *generateView;

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *agreeView;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeTipsLabel;
@property (weak, nonatomic) IBOutlet AMButton *agreeBtn;

@property (weak, nonatomic) IBOutlet AMButton *publishBtn;
@property (weak, nonatomic) IBOutlet AMButton *deleteBtn;
@property (nonatomic ,strong) AMButton *rightBtn;

///是否包含作品
@property (nonatomic ,assign) BOOL haveFoods;
///是否需要销售(NO:非卖品)
@property (nonatomic ,assign) BOOL needSell;
///是否同意了协议
@property (nonatomic ,assign) BOOL isSelectAgreement;

@property (nonatomic ,strong) NSMutableArray <VideoGoodsImageModel *>*imagesArray;
@property (nonatomic ,strong) NSMutableArray <VideoColumnModel *>*columnArray;
@property (nonatomic ,strong) TXUGCPublish *videoPublish;

@property (nonatomic) dispatch_group_t group;

@end

@implementation PublishVideoViewController {
	///审核状态：0未申请，1已申请，2已通过，3审核失败
	NSInteger _examineType, _generateCount;
	///是否可以存草稿
	BOOL _isCanSaveDraft;
    BOOL _translucent, _isEditing, _needGenerate;
}

- (TXUGCPublish *)videoPublish {
    if (!_videoPublish) {
        _videoPublish = [[TXUGCPublish alloc] init];
        _videoPublish.delegate = self;
    }return _videoPublish;
}

- (dispatch_group_t)group {
    if (!_group) {
        _group = dispatch_group_create();
    }return _group;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!self.videoModel && self.videoEdit) {
        self.videoModel = [[VideoListModel alloc] init];
        self.videoModel.video_localurl = self.videoEdit.videoOutputPath;
        self.videoModel.needPublish = YES;
        self.videoModel.check_state = @"0";
        self.videoModel.is_include_obj = @"0";
        self.videoModel.modify_state = NO;
        self.videoModel.canSaveDraft = YES;
        self.videoModel.needGenerate = YES;
        self.videoModel.needPublish = YES;
        self.videoModel.video_length = [NSString stringWithFormat:@"%.f",[TXVideoInfoReader getVideoInfo:self.videoModel.video_localurl].duration];
    }
    
    _generateCount = 0;
    
	_publishBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
	_deleteBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    [_publishBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [_publishBtn setBackgroundImage:[UIImage imageWithColor:Color_Grey] forState:UIControlStateDisabled];
    
    _deleteBtn.hidden = YES;
	
	if (self.videoModel && self.videoModel.goodsModel) {
		self.videoModel.goodsModel.freeshipping = YES;
	}
	
	_haveFoods = self.videoModel.is_include_obj.boolValue;
	_isSelectAgreement = YES;
	_examineType = self.videoModel.check_state.integerValue;
    _isEditing = self.videoModel.modify_state;
    _needGenerate = self.videoModel.needGenerate;
    _isCanSaveDraft = NO;
    _needSell = self.videoModel.goodsModel.good_sell_type;
	if (_haveFoods && self.videoModel.goodsModel.auctionpic) {
        _imagesArray = self.videoModel.goodsModel.auctionpic.mutableCopy;
	}else
        _imagesArray = @[].mutableCopy;
    
    _columnArray = @[].mutableCopy;
    
    _agreeLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _agreeTipsLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    NSString *agreement = [NSString stringWithFormat:@"《%@视频上传用户协议》", AMBundleName];
    _agreeLabel.text = agreement;
    _agreeBtn.selected = _isSelectAgreement;
	
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    self.tableView.estimatedSectionFooterHeight = 44.0f;
    self.tableView.estimatedSectionHeaderHeight = 44.0f;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
	
	[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PublishVideoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PublishVideoCell class])];
	[_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PublishGoodsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PublishGoodsCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsSellTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GoodsSellTableCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (_needGenerate) {
        self.videoEdit.ugcEdit.generateDelegate = self;
        [self generateVideo];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    _translucent = self.navigationController.navigationBar.translucent;
    self.navigationController.navigationBar.translucent = !_translucent;
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationItem setTitle:@"编辑信息"];
    self.navigationController.navigationBar.frame = CGRectMake(0, StatusBar_Height, K_Width, NavBar_Height);

	if (_isCanSaveDraft) {
		AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
		[rightBtn setTitle:@"存草稿" forState:UIControlStateNormal];
		[rightBtn setTitleColor:Color_Black forState:UIControlStateNormal];
		[rightBtn setTitleColor:Color_Grey forState:UIControlStateDisabled];
		rightBtn.titleLabel.font = [UIFont addHanSanSC:16.0f fontType:0];
		[rightBtn addTarget:self action:@selector(clickToSaveDraft:) forControlEvents:UIControlEventTouchUpInside];
		
		_rightBtn = rightBtn;
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
	}
	[self judgeBottomBtnColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = _translucent;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isEditing) {
        return 1;
    }
    if ([UserInfoManager shareManager].isArtist) {
        return  _haveFoods?3:2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 && !_haveFoods)
        return 0;
    if (section == 2 && !_needSell)
        return 0;
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_examineType == 3 && section == 0) return UITableViewAutomaticDimension;
    if(section == 1 || section == 2) return section%2?66.0f:44.0f;
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *wrapView = [[UIView alloc] init];
    if (section == 1 || section == 2) {
        wrapView.frame = CGRectMake(0, 0, K_Width, section%2?66.0f:44.0f);
		wrapView.backgroundColor = Color_Whiter;
		AMButton *goodsBtn = [AMButton buttonWithType:UIButtonTypeCustom];
		goodsBtn.frame = CGRectMake(0, 0, (wrapView.height*2/3)*2, wrapView.height*2/3);
		[wrapView addSubview:goodsBtn];
		goodsBtn.contentHorizontalAlignment = NSTextAlignmentRight;
		
		[goodsBtn setImage:ImageNamed(@"switch_close") forState:UIControlStateNormal];
		[goodsBtn setImage:ImageNamed(@"switch_open") forState:UIControlStateSelected];
        
        [goodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wrapView.mas_right).offset(-15.0f);
            make.centerY.equalTo(wrapView);
            make.width.offset(goodsBtn.width);
            make.height.offset(goodsBtn.height);
        }];

		UILabel *nameLabel = [[UILabel alloc] init];
		
		nameLabel.font = [UIFont addHanSanSC:14.0f fontType:1];
		nameLabel.textColor = Color_Black;
        nameLabel.numberOfLines = 0;
		
		[wrapView addSubview:nameLabel];
		[nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(wrapView.mas_left).offset(15.0f);
			make.height.centerY.equalTo(wrapView);
			make.right.lessThanOrEqualTo(goodsBtn.mas_left).offset(-ADAptationMargin);
		}];
        if (section == 1) {
            goodsBtn.selected = _haveFoods;
            [goodsBtn addTarget:self action:@selector(clickToNeedGoods:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *tipsText = @"可选择是否销售作品";
            NSString *allText = [NSString stringWithFormat:@"认证视频中的创作作品\n%@",tipsText];
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allText];
            [attr addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x999999), NSFontAttributeName:[UIFont addHanSanSC:12.0 fontType:0]} range:[allText rangeOfString:tipsText]];
            
            nameLabel.attributedText = attr;
        }
        if (section == 2) {
            goodsBtn.selected = _needSell;
            [goodsBtn addTarget:self action:@selector(clickToNeedSell:) forControlEvents:UIControlEventTouchUpInside];
            
            nameLabel.text = @"是否售卖：";
        }
	}
    if (_examineType == 3 && section == 0) {
        UILabel *reasonLabel = [[UILabel alloc] init];
        reasonLabel.backgroundColor = Color_Whiter;
        reasonLabel.numberOfLines = 0;
        
        NSString *reason = [ToolUtil isEqualToNonNullKong:self.videoModel.check_explain];
        NSString *textString = [NSString stringWithFormat:@"\n审核未通过：%@\n",reason];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString attributes:@{NSFontAttributeName:[UIFont addHanSanSC:14.0f fontType:0], NSForegroundColorAttributeName:Color_Black}];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.headIndent = 15.0f;
        paragraphStyle.firstLineHeadIndent  = 15.0f;
        paragraphStyle.tailIndent = -15.0f;
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_Red range:[textString rangeOfString:reason]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont addHanSanSC:14.0f fontType:0] range:[textString rangeOfString:textString]];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[textString rangeOfString:textString]];
        
        reasonLabel.attributedText = attributedString;
        
        [wrapView addSubview:reasonLabel];
        [reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(wrapView).offset(0);
            make.bottom.equalTo(wrapView.mas_bottom).offset(-ADAptationMargin);
            make.height.greaterThanOrEqualTo(@44);
        }];
    }
	return wrapView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return ADAptationMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
		PublishVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PublishVideoCell class]) forIndexPath:indexPath];
        
        cell.delegate = self;
        [cell updateColumn:_columnArray.copy withSelectColumn:self.videoModel.columnModel];
		[cell setPublishVideoCellWithImage:self.videoModel.image_url videoIntro:self.videoModel.video_des];
        
		return cell;
    }else if (indexPath.section == 1) {
		PublishGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PublishGoodsCell class]) forIndexPath:indexPath];
		
        cell.delegate = self;
		cell.goodsModel = self.videoModel.goodsModel;
        [cell reloadCollectView:_imagesArray.copy];
		
		return cell;
    }else {
        GoodsSellTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GoodsSellTableCell class]) forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.goodsModel = self.videoModel.goodsModel;
        
        return cell;
    }
}

#pragma mark -
/// reloaload
/// @param cell cell
/// @param sender sender
- (void)goodsCell:(PublishGoodsCell *)cell reloaload:(id _Nullable)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationNone)];
}

/// 选择作品图片
/// @param cell cell
/// @param sender sender
- (void)goodsCell:(PublishGoodsCell *)cell pickGoodsIV:(id _Nullable)sender {
    
    AMImageSelectDialogView *dialogView = [AMImageSelectDialogView shareInstance];
    dialogView.title = @"选择图片";
    @weakify(dialogView);
    dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
        @strongify(dialogView);
        [dialogView hide];
        [ToolUtil showInControllerWithoutUpload:self photoOfMax:9-_imagesArray.count withType:meidaType completion:^(NSArray * _Nullable images) {
            [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                VideoGoodsImageModel *model = [[VideoGoodsImageModel alloc] init];
                model.imgsrc = obj;
                [_imagesArray insertObject:model atIndex:_imagesArray.count];
            }];
            [self judgeBottomBtnColor];
            [self.tableView reloadData];
        }];
//        [ToolUtil showInController:self photoOfMax:9-_imagesArray.count withType:meidaType uploadType:4 completion:^(NSArray * _Nullable images) {
//            [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                VideoGoodsImageModel *model = [[VideoGoodsImageModel alloc] init];
//                model.imgsrc = obj;
//                [_imagesArray insertObject:model atIndex:_imagesArray.count];
//            }];
//            [self judgeBottomBtnColor];
//            [self.tableView reloadData];
//        }];
    };
    [dialogView show];
}

/// 删除作品图片
- (void)goodsCell:(PublishGoodsCell *)cell deleteGoodsIV:(NSInteger)imageIndex {
    [_imagesArray removeObjectAtIndex:imageIndex];
    [self judgeBottomBtnColor];
    [self.tableView reloadData];
}

/// 记录用户输入内容
/// @param cell cell
- (void)goodsCell:(PublishGoodsCell *)cell userInputResultWithinputStr:(NSString *_Nullable)inputStr index:(NSInteger)styleIndex {
    switch (styleIndex) {
        case 0:
            self.videoModel.goodsModel.name = [ToolUtil isEqualToNonNullKong:inputStr];
            break;
        case 1:
            self.videoModel.goodsModel.describe = [ToolUtil isEqualToNonNullKong:inputStr];
            break;
            
        default:
            break;
    }
    [self judgeBottomBtnColor];
}

/// 选择作品分类
- (void)goodsCell:(PublishGoodsCell *)cell selectGoodsClass:(VideoGoodsModel *)goodsModel {
    GoodsClassViewController *classVC = [[GoodsClassViewController alloc] init];
    classVC.delegate = self;
    if ([ToolUtil isEqualToNonNullKong:goodsModel.classModel.id]) {
        classVC.classModel = goodsModel.classModel;
    }
    [self.navigationController presentViewController:classVC animated:YES completion:nil];
}

- (void)goodsCell:(PublishGoodsCell *)cell selectGoodsCreateDate:(VideoGoodsModel * _Nullable)goodsModel {
    BRDatePickerView *pickerView = [[BRDatePickerView alloc] init];
    pickerView.pickerMode = BRDatePickerModeYMD;
    pickerView.isAutoSelect = NO;
    
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = UIColor.whiteColor;
    customStyle.pickerTextColor = Color_Black;
    customStyle.separatorColor = UIColorFromRGB(0xCCCCCC);
    pickerView.pickerStyle = customStyle;
    
    pickerView.selectDate = [NSDate br_dateFromString:_videoModel.goodsModel.good_created_time dateFormat:AMDataFormatter3];
    pickerView.maxDate = [NSDate date];
    pickerView.minDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    pickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        self.videoModel.goodsModel.good_created_time = [NSDate br_stringFromDate:selectDate dateFormat:AMDataFormatter3];
        cell.goodsDateTF.text = self.videoModel.goodsModel.good_created_time;
    };
    
    [pickerView show];
}

#pragma mark - PublishVideoCellDelegate
/// 视频简介输入
- (void) videoCell:(PublishVideoCell *)videoCell introTextChanged:(NSString *)introText {
    NSLog(@"introTextChangeBlock = %@",introText);
    self.videoModel.video_des = introText;
    [self judgeBottomBtnColor];
}
/// 视频频道选择
- (void) videoCell:(PublishVideoCell *)videoCell columnChanged:(VideoColumnModel *)selectedColumn {
    if (![selectedColumn.id isEqualToString:self.videoModel.columnModel.id]) {
        self.videoModel.columnModel = selectedColumn;
        [self.tableView reloadData];
    }
}
/// 根据已选频道刷新UI
- (void) videoCell:(PublishVideoCell *)videoCell reloadWithColumn:(id)sender {
    [self loadColumn];
}

/// 编辑视频封面
- (void) videoCell:(PublishVideoCell *)videoCell editVideoCover:(id)sender {
    if (self.videoEdit && [ToolUtil isEqualToNonNull:self.videoEdit.videoOutputPath]) {
        CZHChooseCoverController *chooseCover = [[CZHChooseCoverController alloc] init];
        chooseCover.videoPath = [NSURL fileURLWithPath:self.videoEdit.videoOutputPath];
        chooseCover.coverImageBlock = ^(UIImage *coverImage) {
            self.videoModel.image_url = coverImage;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
//            [SVProgressHUD showWithStatus:@"图片上传中，请稍后..."];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [ToolUtil uploadImgs:@[coverImage] uploadType:5 completion:^(NSArray * _Nullable imageURls) {
//                    [self uploadCoverImg:imageURls];
//                }];
//            });
        };
        [self presentViewController:chooseCover animated:YES completion:nil];
    }else {
        AMImageSelectDialogView *dialogView = [AMImageSelectDialogView shareInstance];
        dialogView.title = @"设置封面";
        dialogView.itemData = @[@"拍一张", @"从手机相册选择"];
        @weakify(dialogView);
        dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
            @strongify(dialogView);
            [dialogView hide];
            [ToolUtil showInControllerWithoutUpload:self photoOfMax:1 withType:meidaType completion:^(NSArray * _Nullable images) {
                self.videoModel.image_url = images.lastObject;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
//            [ToolUtil showInController:self photoOfMax:1 withType:meidaType uploadType:5 completion:^(NSArray * _Nullable images) {
//                [self uploadCoverImg:images];
//            }];
        };
        [dialogView show];
    }
}

- (void)uploadCoverImg:(NSArray *)images {
    self.videoModel.image_url = images.lastObject;
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark -  GoodsClassDelegate
- (void)viewController:(BaseViewController *)viewController didSelectedGoodsClass:(GoodsClassModel *)classModel {
    self.videoModel.goodsModel.classModel = classModel;
    [self judgeBottomBtnColor];
    [self.tableView reloadData];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GoodsSellTableCellDelegate
/// 记录用户输入的价格
- (void)sellCell:(GoodsSellTableCell *)cell userInputResultForPriceWithinputStr:(NSString *)inputStr {
    
    self.videoModel.goodsModel.sellprice = [ToolUtil isEqualToNonNullKong:inputStr];
    
    [self judgeBottomBtnColor];
}
/// 包邮
- (void)sellCell:(GoodsSellTableCell *)cell selecIstMail:(BOOL)isMail {
    self.videoModel.goodsModel.freeshipping = isMail;
}

#pragma mark - TXVideoGenerateListener
-(void) onGenerateProgress:(float)progress {
    [_generateView setProgress:progress forType:0];
}

- (void) onGenerateComplete:(TXGenerateResult *)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (result.retCode == 0) {
        _generateView.hidden = YES;
        [self dealVideoCover];
    }else {
        NSString *descMsg = result.descMsg;
        if (_generateCount < 2) {
            descMsg = [NSString stringWithFormat:@"%@, 正在重试...", result.descMsg];
        }
        @weakify(self);
        [SVProgressHUD showError:descMsg completion:^{
            if (self->_generateCount < 2) {
                @strongify(self);
                [self generateVideo];
            }
        }];
    }
}

- (void)dealVideoCover {
    TXVideoInfo *videoInfo = [TXVideoInfoReader getVideoInfo:self.videoEdit.videoOutputPath];
    CGFloat width  = 0.0f;
    CGFloat height = 0.0f;
    CGRect frame = CGRectZero;
    if (videoInfo.coverImage.size.width <= videoInfo.coverImage.size.height) {
        /// 竖屏封面
        width = videoInfo.coverImage.size.width;
        height = videoInfo.coverImage.size.height;
        frame = CGRectMake(0, (height - width)/2, width, width);
    }else {
        width = videoInfo.coverImage.size.height;
        height = videoInfo.coverImage.size.width;
        frame = CGRectMake((height - width)/2, 0, width, width);
    }
    if (CGRectEqualToRect(frame, CGRectZero)) {
        self.videoModel.image_url = videoInfo.coverImage;
    }else {
        self.videoModel.image_url = [videoInfo.coverImage croppedImageWithFrame:frame angle:0.0 circularClip:NO];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - TXVideoPublishListener
-(void)onPublishProgress:(uint64_t)uploadBytes totalBytes: (uint64_t)totalBytes
{
    [_generateView setProgress:(float)uploadBytes/totalBytes forType:1];
}

-(void)onPublishComplete:(TXPublishResult*)result {
    NSLog(@"onPublishComplete = %@",[result yy_modelToJSONObject]);
    self.generateView.hidden = YES;
    
    if (result.retCode == 0) {
        self.videoModel.video_file_id = result.videoId;
        self.videoModel.video_url = result.videoURL;
        self.videoModel.needPublish = NO;
    }
    dispatch_group_leave(self.group);
}

#pragma mark -
- (void)clickToSaveDraft:(id)sender {
	[self postVideo:0];
}

- (IBAction)clickToPublish:(AMButton *)sender {
    if (_isEditing) {
        [self editVideo];
    }else
        [self postVideo:1];
}

- (IBAction)clickToDelete:(AMButton *)sender {
	AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否要删除该视频？" buttonArray:@[@"是", @"否"] confirm:^{
		dispatch_async(dispatch_get_main_queue(), ^{
            [ApiUtil postWithParent:self url:[ApiUtilHeader deleteVideo] params:@{@"videoid":[ToolUtil isEqualToNonNullKong:self.videoModel.ID]} success:^(NSInteger code, id  _Nullable response) {
                [SVProgressHUD showSuccess:@"删除视频成功" completion:^{
                    [self exit];
                }];
            } fail:nil];
		});
	} cancel:nil];
	[alert show];
}

- (void)clickToNeedGoods:(AMButton *)sender {
	if (!_haveFoods && [UserInfoManager shareManager].model.utype.integerValue != 3) {
		AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"成为认证艺术家后，可发布作品" buttonArray:@[@"前往认证",@"取消"] confirm:^{
			[self.navigationController pushViewController:[IdentifyViewController new] animated:YES];
		} cancel:nil];
		[alert show];
		return;
	}else {
		sender.selected = !sender.selected;
		_haveFoods = sender.selected;
		if (_haveFoods) {
			if (!self.videoModel.goodsModel) {
				self.videoModel.goodsModel = [VideoGoodsModel new];
				self.videoModel.goodsModel.freeshipping = YES;
			}
		}
		[self judgeBottomBtnColor];
		[_tableView reloadData];
	}
}
/// 是否可以售卖
- (void)clickToNeedSell:(AMButton *)sender {
    sender.selected = !sender.selected;
    _needSell = sender.selected;
    
    [self judgeBottomBtnColor];
    [_tableView reloadData];
}

- (IBAction)clickToShowAgreement:(AMButton *)sender {
    SystemArticleViewController *agreementVC = [[SystemArticleViewController alloc] init];
    agreementVC.needBottom = YES;
    /// 视频上传用户协议
    agreementVC.articleID = @"YSRMTSPSCYHXY";
    agreementVC.completion = ^{
        _isSelectAgreement = YES;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:agreementVC animated:YES];
}

- (IBAction)clickToAgreeAgreement:(AMButton *)sender {
	sender.selected = !sender.selected;
	_isSelectAgreement = sender.selected;
	[self judgeBottomBtnColor];
}

#pragma mark -
- (BOOL)navigationShouldPopOnBackButton {
	AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"确定放弃当前编辑？" buttonArray:@[@"确定", @"取消"] confirm:^{
		[self exit];
	} cancel:nil];
	[alertView show];
	
	return NO;
}

- (void)exit {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
//type 0：存草稿，1：发布
- (void)postVideo:(NSInteger)type {
	//有无作品 _haveFoods 有无修改 self.videoModel.modify_state
    if (![ToolUtil isEqualToNonNull:self.videoModel.image_url]) {
        [SVProgressHUD showMsg:@"请选择视频封面"];
        return;
    }
	if (![ToolUtil isEqualToNonNull:self.videoModel.video_des]) {
		[SVProgressHUD showMsg:@"请填写视频简介"];
		return;
	}
	if (!_isSelectAgreement) {
		[SVProgressHUD showMsg:@"未同意相关协议"];
		return;
	}
	if (_haveFoods) {
		//无作品 有无修改
		if (![ToolUtil isEqualToNonNull:self.videoModel.goodsModel.name ]) {
			[SVProgressHUD showMsg:@"请填写作品名称"];
			return;
		}
		if (![ToolUtil isEqualToNonNull:self.videoModel.goodsModel.describe ]) {
			[SVProgressHUD showMsg:@"请填写作品介绍"];
			return;
		}
        if (!(self.videoModel.goodsModel.classModel &&
              [ToolUtil isEqualToNonNull:self.videoModel.goodsModel.classModel.id] &&
              self.videoModel.goodsModel.classModel.secondcate.count &&
              [ToolUtil isEqualToNonNull:self.videoModel.goodsModel.classModel.secondcate.lastObject.id])) {
            [SVProgressHUD showMsg:@"请选择作品分类"];
            return;
        }
        if (!_imagesArray.count) {
            [SVProgressHUD showMsg:@"请选择作品图片"];
            return;
        }
        if (_needSell) {
            if (![ToolUtil isEqualToNonNull:self.videoModel.goodsModel.sellprice]) {
                [SVProgressHUD showMsg:@"请填写作品价格"];
                return;
            }
            if (self.videoModel.goodsModel.sellprice.doubleValue < 1.00) {
                [SVProgressHUD showMsg:@"商品价格需大于等于1元"];
                return;
            }
        }
	}
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    /// 上传封面图
    if ([self.videoModel.image_url isKindOfClass:[UIImage class]]) {
        dispatch_group_async(self.group, dispatch_get_global_queue(0, 0), ^{
            dispatch_group_enter(self.group);
            [ToolUtil uploadImgs:@[self.videoModel.image_url] uploadType:5 completion:^(NSArray * _Nullable imageURls) {
                self.videoModel.image_url = imageURls.lastObject;
                dispatch_group_leave(self.group);
            } fail:^(NSString * _Nonnull errorMsg) {
                dispatch_group_leave(self.group);
            }];
        });
    }
    
    /// 上传商品图片
    if (_haveFoods && _imagesArray && _imagesArray.copy) {
        NSMutableArray *imageArray = _imagesArray.mutableCopy;
        NSMutableArray *images = @[].mutableCopy;
        [imageArray enumerateObjectsUsingBlock:^(VideoGoodsImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.imgsrc isKindOfClass:[UIImage class]]) {
                [images addObject:obj.imgsrc];
                [_imagesArray removeObject:obj];
            }
        }];
        if (images.count) {
            dispatch_group_async(self.group, dispatch_get_global_queue(0, 0), ^{
                dispatch_group_enter(self.group);
                [ToolUtil uploadImgs:images.copy uploadType:4 completion:^(NSArray * _Nullable imageURls) {
                    [imageURls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        VideoGoodsImageModel *model = [[VideoGoodsImageModel alloc] init];
                        model.imgsrc = obj;
                        [_imagesArray insertObject:model atIndex:_imagesArray.count];
                    }];
                    dispatch_group_leave(self.group);
                } fail:^(NSString * _Nonnull errorMsg) {
                    dispatch_group_leave(self.group);
                }];
            });
        }
    }
    
    /// 上传视频
    if (self.videoModel.needPublish && ![ToolUtil isEqualToNonNull:self.videoModel.video_file_id]) {
        dispatch_group_async(self.group, dispatch_get_global_queue(0, 0), ^{
            dispatch_group_enter(self.group);
            [ApiUtil postWithParent:self url:[ApiUtilHeader getUploadSignature] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
                NSString *signature = (NSString *)[response objectForKey:@"data"];
                if ([ToolUtil isEqualToNonNull:signature]) {
                    self.generateView.hidden = NO;
                    
                    TXPublishParam *publishParam = [[TXPublishParam alloc] init];
                    publishParam.signature  = signature;
                    publishParam.videoPath  = self.videoEdit.videoOutputPath;
                    [self.videoPublish publishVideo:publishParam];
                }
            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                dispatch_group_leave(self.group);
            }];
        });
    }
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (![ToolUtil isEqualToNonNull:self.videoModel.video_file_id]) {
            [SVProgressHUD showMsg:@"上传视频失败 ，请重新发布"];
            return;
        }
        if (![ToolUtil isEqualToNonNull:self.videoModel.image_url] || [self.videoModel.image_url isKindOfClass:[UIImage class]]) {
            [SVProgressHUD showMsg:@"封面上传失败，请重新发布"];
            return;
        }
        if (!_haveFoods) {
            [self postVideoWithoutGoods:type];
        }else {
            if (![self hasUploadAllGoodsImg]) {
                [SVProgressHUD showMsg:@"作品图片上传失败，请重新发布"];
                return;
            }
            if (type) {//type 0：存草稿，1：发布
                /// 发布
                [self postVideoWithGoods];
            }else {
                /// 存草稿
                [self saveVideoWithGoods];
            }
        }
    });
}

- (BOOL) hasUploadAllGoodsImg {
    __block BOOL hadAllUploaded = YES;
    [_imagesArray enumerateObjectsUsingBlock:^(VideoGoodsImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.imgsrc isKindOfClass:[UIImage class]]) {
            hadAllUploaded = NO;
            *stop = YES;
        }
    }];
    return hadAllUploaded;
}

/// 带商品视频存草稿 modify_state 0:无修改 1:有修改
- (void)saveVideoWithGoods {
    NSString *urlString = self.videoModel.modify_state?[ApiUtilHeader saveVideoWithGoodsWithModeify]:[ApiUtilHeader saveVideoWithGoodsWithoutModeify];
    
    NSMutableDictionary *videoData = [NSMutableDictionary new];
    
    videoData[@"id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.ID];
    videoData[@"video_url"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_url];
    videoData[@"image_url"] = [ToolUtil isEqualToNonNullKong:self.videoModel.image_url];
    videoData[@"video_des"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_des];
    videoData[@"video_state"] = @"0";
    videoData[@"video_length"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_length];
    
    NSMutableDictionary *goodsData = [NSMutableDictionary new];
    
    goodsData[@"auctionpic"] = [self getPostImageUrls];
    goodsData[@"aname"] = [ToolUtil isEqualToNonNullKong:self.videoModel.goodsModel.name];
    goodsData[@"description"] = [ToolUtil isEqualToNonNullKong:self.videoModel.goodsModel.describe];
    goodsData[@"price"] = [ToolUtil isEqualToNonNullKong:self.videoModel.goodsModel.sellprice];
    goodsData[@"freeshipping"] = StringWithFormat(@(self.videoModel.goodsModel.freeshipping));
    
    goodsData[@"acate_id"] = self.videoModel.goodsModel.classModel.secondcate.lastObject.id;
    goodsData[@"acate_name"] = self.videoModel.goodsModel.classModel.secondcate.lastObject.scate_name;
    
    
    videoData[@"stock_data"] = goodsData;
    videoData[@"column_id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.columnModel.id];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"video_data"] = videoData;
    
    [ApiUtil postWithParent:self url:urlString params:params.copy success:^(NSInteger code, id  _Nullable response) {
        AMAlertView *alertView = [AMAlertView shareInstanceWithTitle:@"保存成功" buttonArray:@[@"确定"] confirm:^{
            [self exit];
        } cancel:nil];
        [alertView show];
    } fail:nil];
}

/// 带商品视频发布 modify_state 0:无修改 1:有修改
- (void)postVideoWithGoods {
    NSString *urlString = self.videoModel.modify_state?[ApiUtilHeader publishVideoWithGoodsWithModeify]:[ApiUtilHeader publishVideoWithGoodsWithoutModeify];
    
    NSMutableDictionary *videoData = [NSMutableDictionary new];
    
//    videoData[@"id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.ID];
    if (self.videoModel.modify_state) {
        videoData[@"id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.ID];
    }else {
        videoData[@"video_file_id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_file_id];
    }
    videoData[@"video_url"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_url];
    videoData[@"image_url"] = [ToolUtil isEqualToNonNullKong:self.videoModel.image_url];
    videoData[@"video_des"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_des];
    videoData[@"video_state"] = @"1";
    videoData[@"video_length"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_length];
    
    NSMutableDictionary *goodsData = [NSMutableDictionary new];
    
    goodsData[@"auctionpic"] = [self getPostImageUrls];
    goodsData[@"gname"] = [ToolUtil isEqualToNonNullKong:self.videoModel.goodsModel.name];
    goodsData[@"gdescribe"] = [ToolUtil isEqualToNonNullKong:self.videoModel.goodsModel.describe];
    goodsData[@"gprice"] = [ToolUtil isEqualToNonNullKong:self.videoModel.goodsModel.sellprice];
    goodsData[@"gfreeshipping"] = StringWithFormat(@(self.videoModel.goodsModel.freeshipping));
    
    goodsData[@"gcate_id"] = self.videoModel.goodsModel.classModel.secondcate.lastObject.id;
    goodsData[@"gcate_name"] = self.videoModel.goodsModel.classModel.secondcate.lastObject.scate_name;
    
    goodsData[@"good_sell_type"] = StringWithFormat(@(_needSell));
    goodsData[@"good_created_time"] = [ToolUtil isEqualToNonNullForZanWu:self.videoModel.goodsModel.good_created_time];
    
    videoData[@"goodsdata"] = goodsData;
    videoData[@"column_id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.columnModel.id];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"video_data"] = videoData;
    
    [ApiUtil postWithParent:self url:urlString params:params.copy success:^(NSInteger code, id  _Nullable response) {
        PublishResultViewController *resultVC = [[PublishResultViewController alloc] init];
        resultVC.hadGoods = YES;
        resultVC.videoName = self.videoModel.goodsModel.name;
        NSArray *data = (NSArray *)[response objectForKey:@"data"];
        if (data && data.count) {
            resultVC.artworkIDCard = [ToolUtil isEqualToNonNullKong:data.firstObject];
        }
        [self.navigationController pushViewController:resultVC animated:YES];
    } fail:nil];
}

///发布/保存视频，不带作品，type 0：存草稿，1：发布
- (void)postVideoWithoutGoods:(NSInteger)type {
	[SVProgressHUD show];
	NSString *urlString = self.videoModel.modify_state?[ApiUtilHeader postVideoWithoutGoodsWithModeify]:[ApiUtilHeader postVideoWithoutGoodsWithoutModeify];
	
	NSMutableDictionary *videoData = [NSMutableDictionary new];
	if (self.videoModel.modify_state) {
		videoData[@"id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.ID];
	}else {
		videoData[@"video_file_id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_file_id];
	}
	
	videoData[@"video_url"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_url];
	videoData[@"image_url"] = [ToolUtil isEqualToNonNullKong:self.videoModel.image_url];
	videoData[@"video_des"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_des];
	videoData[@"video_state"] = StringWithFormat(@(type));
	videoData[@"video_length"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_length];
    videoData[@"column_id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.columnModel.id];
	
	NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
	params[@"video_data"] = videoData;
	
    [ApiUtil postWithParent:self url:urlString params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.navigationController pushViewController:[[PublishResultViewController alloc] init] animated:YES];
    } fail:nil];
}

- (void)editVideo {
    if (![ToolUtil isEqualToNonNull:self.videoModel.image_url]) {
        [SVProgressHUD showMsg:@"请选择视频封面"];
        return;
    }
    if (![ToolUtil isEqualToNonNull:self.videoModel.video_des]) {
        [SVProgressHUD showMsg:@"请填写视频简介"];
        return;
    }
    if (!_isSelectAgreement) {
        [SVProgressHUD showMsg:@"未同意相关协议"];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    /// 上传封面图
    if ([self.videoModel.image_url isKindOfClass:[UIImage class]]) {
        dispatch_group_async(self.group, dispatch_get_global_queue(0, 0), ^{
            dispatch_group_enter(self.group);
            [ToolUtil uploadImgs:@[self.videoModel.image_url] uploadType:5 completion:^(NSArray * _Nullable imageURls) {
                self.videoModel.image_url = imageURls.lastObject;
                dispatch_group_leave(self.group);
            } fail:^(NSString * _Nonnull errorMsg) {
                dispatch_group_leave(self.group);
            }];
        });
    }
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (![ToolUtil isEqualToNonNull:self.videoModel.image_url] || [self.videoModel.image_url isKindOfClass:[UIImage class]]) {
            [SVProgressHUD showMsg:@"封面上传失败，请重新发布"];
            return;
        }
        
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"uid"] = [UserInfoManager shareManager].uid;
        params[@"video_id"] = [ToolUtil isEqualToNonNullKong:self.videoModel.ID];
        params[@"image_url"] = [ToolUtil isEqualToNonNullKong:self.videoModel.image_url];
        params[@"video_des"] = [ToolUtil isEqualToNonNullKong:self.videoModel.video_des];
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader editVideoInfo] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            [self.navigationController pushViewController:[[PublishResultViewController alloc] init] animated:YES];
        } fail:nil];
    });
}

#pragma mark -
- (void)uploadGoodsImages:(dispatch_semaphore_t)semaphore images:(NSArray *)images {
    [SVProgressHUD showWithStatus:@"图片上传中，请稍后..."];
    [ToolUtil uploadImgs:images uploadType:4 completion:^(NSArray * _Nullable imageURls) {
        [imageURls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VideoGoodsImageModel *model = [[VideoGoodsImageModel alloc] init];
            model.imgsrc = obj;
            [_imagesArray insertObject:model atIndex:_imagesArray.count];
        }];
        self.videoModel.goodsModel.auctionpic = [_imagesArray copy];
        dispatch_semaphore_signal(semaphore);
    }];
}

- (void)judgeBottomBtnColor {
    BOOL enabled = NO;
    if (_isEditing) {
        if ([ToolUtil isEqualToNonNull:self.videoModel.video_des] && _isSelectAgreement) {
            enabled = YES;
        }
    }else {
        if (_haveFoods) {
            if ([ToolUtil isEqualToNonNull:self.videoModel.video_des] &&///视频描述判断
                _isSelectAgreement &&///协议判断
                [ToolUtil isEqualToNonNull:self.videoModel.goodsModel.name] &&/// 名称判断
//                 [ToolUtil isEqualToNonNull:self.videoModel.goodsModel.describe] &&///介绍判断
                 _imagesArray.count) {/// 图片判断
                enabled = YES;

                if (self.videoModel.goodsModel.classModel && /// 分类判断
                    [ToolUtil isEqualToNonNull:self.videoModel.goodsModel.classModel.id] &&
                    self.videoModel.goodsModel.classModel.secondcate.count &&
                    [ToolUtil isEqualToNonNull:self.videoModel.goodsModel.classModel.secondcate.lastObject.id]) {
                    enabled = YES;
                }else
                    enabled = NO;

                if (_needSell) {
                    enabled = [ToolUtil isEqualToNonNull:self.videoModel.goodsModel.sellprice]?YES:NO;
                }
            }

        }else {
            if ([ToolUtil isEqualToNonNull:self.videoModel.video_des ] && _isSelectAgreement) {
                enabled = YES;
            }
        }
    }
    _publishBtn.enabled = enabled;
    if (_isCanSaveDraft) {
        _rightBtn.enabled = enabled;
    }
}

- (NSArray *)getPostImageUrls {
    NSMutableArray *imageUrls = [NSMutableArray new];
    [_imagesArray enumerateObjectsUsingBlock:^(VideoGoodsImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageUrls insertObject:obj.imgsrc atIndex:imageUrls.count];
    }];
    return imageUrls.copy;
}

/// 生成视频
- (void)generateVideo {
    _generateView.hidden = NO;
    [_generateView setProgress:0.0 forType:0];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.videoEdit.config.generateMode == UGCKitGenerateModeTwoPass) {
        [self.videoEdit.ugcEdit generateVideoWithTwoPass:self.videoEdit.config.compressResolution videoOutputPath:self.videoEdit.videoOutputPath];
    } else {
        [self.videoEdit.ugcEdit generateVideo:self.videoEdit.config.compressResolution videoOutputPath:self.videoEdit.videoOutputPath];
    }
}

#pragma mark -
- (void)loadColumn {
    [ApiUtil postWithParent:self url:[ApiUtilHeader getVideoColumn] params:nil success:^(NSInteger code, id  _Nullable response) {
        NSArray *array = (NSArray *)response[@"data"];
        if (array && array.count) {
            if (_columnArray.count) [_columnArray removeAllObjects];
            [_columnArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VideoColumnModel class] json:array]];
        }
        if (_columnArray.count) {
            [_columnArray enumerateObjectsUsingBlock:^(VideoColumnModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.id isEqualToString:self.videoModel.column_id]) {
                    self.videoModel.columnModel = obj;
                    *stop = YES;
                }
            }];
        }
        if (!self.videoModel.columnModel) {
            self.videoModel.columnModel = _columnArray.firstObject;
        }
        [self.tableView reloadData];
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
