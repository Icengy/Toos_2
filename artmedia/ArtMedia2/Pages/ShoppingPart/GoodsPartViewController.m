//
//  GoodsPartViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsPartViewController.h"

#import "OrderFillViewController.h"
#import "VideoPlayerViewController.h"
//#import "CustomPersonalViewController.h"
#import "AMBaseUserHomepageViewController.h"

//#import <WebKit/WebKit.h>

#import "GoodsPartIntroTableCell.h"
#import "GoodsPartBannerView.h"
#import "GoodsPartVideoListCell.h"
#import "GoodsPartItemHeaderView.h"
#import "GoodsPartArtTableCell.h"
#import "GoodsPartWebTableCell.h"
#import "GoodsImageCell.h"

#import "AMShareView.h"
#import "GoodsEditView.h"
#import "GoodsIDCardView.h"
#import <YBImageBrowser/YBImageBrowser.h>

#import "VideoGoodsModel.h"
#import "GoodsDetailModel.h"

#import "AMPayManager.h"

@interface GoodsPartViewController () <UITableViewDelegate ,UITableViewDataSource, GoodsPartBannerDelegate, GoodsPartVideoListCellDelegate, GoodsPartArtCellDelegate, GoodsEditViewDelegate, GoodsIDCardViewDelegate, GoodsPartWebDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *btnCarrier;
@property (weak, nonatomic) IBOutlet AMButton *buyBtn;
//@property (strong, nonatomic) GoodsPartBannerView *bannerView;
@property (assign, nonatomic) BOOL naviHidden;
@property (nonatomic , strong) GoodsDetailModel *goodsDetailModel;
@property (nonatomic , strong) NSMutableArray <YBIBImageData *>*imageUrls;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation GoodsPartViewController {
    NSMutableDictionary *_goodPageData;
    VideoGoodsModel *_goodsModel;
    UserInfoModel *_userModel;
    CGFloat _webHeight;
}

//- (GoodsPartBannerView *)bannerView {
//    if (!_bannerView) {
//        _bannerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GoodsPartBannerView class]) owner:nil options:nil].lastObject;
//        _bannerView.delegate = self;
//        _bannerView.frame = CGRectMake(0, 0, K_Width, K_Width);
//
//    }return _bannerView;
//}
- (NSMutableArray<YBIBImageData *> *)imageUrls{
    if (!_imageUrls) {
        _imageUrls = [[NSMutableArray alloc] init];
    }
    return _imageUrls;
}
- (void)setGoodsDetailModel:(GoodsDetailModel *)goodsDetailModel{
    _goodsDetailModel = goodsDetailModel;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:goodsDetailModel.goodInfo.gsellprice]];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作品详情";
    // Do any additional setup after loading the view from its nib.
    
    self.buyBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.buyBtn setBackgroundImage:[UIImage imageWithColor:RGB(224, 82, 39)] forState:UIControlStateNormal];
    [self.buyBtn setTitle:@"已售" forState:UIControlStateDisabled];
    [self.buyBtn setBackgroundImage:[UIImage imageWithColor:Color_Grey] forState:UIControlStateDisabled];
    
    _goodPageData = @{}.mutableCopy;
    _naviHidden = YES;
    _webHeight = 0.0f;
    
    _tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.contentInset = UIEdgeInsetsMake(-StatusBar_Height, 0.0f, 0.0f, 0.0f);
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsPartIntroTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GoodsPartIntroTableCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsPartVideoListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GoodsPartVideoListCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsPartArtTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GoodsPartArtTableCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsPartWebTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GoodsPartWebTableCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([GoodsImageCell class])];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    //禁止返回
//    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
//    [self.view addGestureRecognizer:pan];
    
    [self loadData:nil];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _goodsModel.good_sell_type?5:4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.goodsDetailModel.goodAtlas.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) return _webHeight;
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GoodsImageCell class]) forIndexPath:indexPath];
        cell.model = self.goodsDetailModel.goodAtlas[indexPath.row];
        return cell;
    }else if (indexPath.section == 1) {
        GoodsPartIntroTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GoodsPartIntroTableCell class]) forIndexPath:indexPath];
        
        cell.model = _goodsModel;
        cell.categoryData = (NSDictionary *)[_goodPageData objectForKey:@"category"];
        return cell;
    }else if (indexPath.section == 2) {
        GoodsPartVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GoodsPartVideoListCell class]) forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.videoArray = (NSArray *)[_goodPageData objectForKey:@"video_list"];
        return cell;
    }else if (indexPath.section == 3) {
        GoodsPartArtTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GoodsPartArtTableCell class]) forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.model = _userModel;
        
        return cell;
    }else {
        GoodsPartWebTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GoodsPartWebTableCell class]) forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.needWeb = _goodsModel.good_sell_type;
        cell.webInfo = (NSDictionary *)[_goodPageData objectForKey:@"exemption"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    if (section == 2) {
        return 40.0f;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        self.bannerView.bannerImgUriArray = (NSArray *)[_goodPageData objectForKey:@"good_atlas"];
//        BOOL hiddenEdit = NO;
//        if ([ToolUtil isEqualOwner:_userModel.id]) {
//            if (_goodsModel.good_sell_type && _goodsModel.status) {
//                hiddenEdit = YES;
//            }
//        }else {
//            hiddenEdit = YES;
//        }
//        self.bannerView.status = hiddenEdit;
//
//        return self.bannerView;
//    }
    if (section == 2) {
        GoodsPartItemHeaderView *headerView = [GoodsPartItemHeaderView shareInstance];
        headerView.isHiddenDetail = (section == 2)?NO:YES;
        if (section == 2) {
            headerView.video_count = StringWithFormat(@([(NSArray *)[_goodPageData objectForKey:@"video_list"] count]));
//            headerView.video_authCode = [(NSDictionary *)[_goodPageData objectForKey:@"good_info"] objectForKey:@"good_auth_code"];
        }
        return headerView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
    
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = self.imageUrls;
        browser.currentPage = indexPath.row;
        [browser show];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
//    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
//    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
//    CGFloat velocity = [pan velocityInView:scrollView].y;
//    NSLog(@"velocity - %.2f",velocity);
//    if (velocity < -5) {//向上拖动，隐藏导航栏
//        _naviHidden = YES;
//        [self.navigationController setNavigationBarHidden:_naviHidden animated:YES];
//    }else if (velocity > 5) {/// 向下拖动，显示导航栏
//        _naviHidden = NO;
//        [self.navigationController setNavigationBarHidden:_naviHidden animated:YES];
//    }
    
//    CGFloat offsetY = scrollView.contentOffset.y;
//    ///隐藏导航栏
//    if (offsetY >= StatusNav_Height) {
//        _naviHidden = NO;
//        [self.navigationController setNavigationBarHidden:_naviHidden animated:YES];
//    }else {
//        _naviHidden = YES;
//        [self.navigationController setNavigationBarHidden:_naviHidden animated:YES];
//    }
}

#pragma mark - GoodsPartBannerDelegate
- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectBannerWithIndex:(NSInteger)index {
//    [self showImagePreview:bannerView.bannerUrl index:index];
}

- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectedBack:(id)sender {
    [self clickToHide:sender];
}

- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectedShare:(id)sender {
    [self clickToShare:sender];
}

- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectedIDCard:(id)sender {
    [self clickToShorIDCard:sender];
}

- (void)bannerView:(GoodsPartBannerView *)bannerView didSelectedEdit:(id)sender {
    [self clickToEdit:sender];
}

#pragma mark - GoodsPartVideoListCellDelegate
- (void)listCell:(GoodsPartVideoListCell *)cell didSelectVideoItem:(NSInteger)index {
    VideoPlayerViewController *videoPlayer = [[VideoPlayerViewController alloc] initWithStyle:MyVideoShowStyleForList videos:(NSArray *)[_goodPageData objectForKey:@"video_list"] playIndex:index listUrlStr:nil params:nil];
    [self.navigationController pushViewController:videoPlayer animated:YES];
}

- (void)listCell:(GoodsPartVideoListCell *)cell didReloadData:(id)sender {
    [self loadData:sender];
}

#pragma mark - GoodsPartArtCellDelegate
- (void)artCell:(GoodsPartArtTableCell *)artCell didSelectedToFollow:(AMButton *)sender {
    if (_userModel.is_collect) {
        AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否取消关注？" buttonArray:@[ @"是", @"否"] confirm:^{
            [self clickToCollect:nil];
        } cancel:nil];
        [alert show];
    }else {
        [self clickToCollect:nil];
    }
}

- (void)clickToCollect:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"collect_uid"] = [ToolUtil isEqualToNonNullKong:_userModel.id];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectUser] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        NSString *keyword = nil;
        if (!_userModel.is_collect) {
            keyword = @"关注成功";
        }else {
            keyword = @"取消关注成功";
        }
        _userModel.is_collect = !_userModel.is_collect;
        [SVProgressHUD showSuccess:keyword completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
                [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:(UITableViewRowAnimationNone)];
            });
        }];
        
    } fail:nil];
}

- (void)artCell:(GoodsPartArtTableCell *)artCell didSelectedToShowArtHome:(id)sender {
    [self clickToShowHome:sender];
}

#pragma mark - GoodsEditViewDelegate
/// 是否售卖作品
- (void)editView:(GoodsEditView *)editView selecIstToSell:(BOOL)isSell {
    _goodsModel.good_sell_type = isSell;
}

/// 记录用户输入的价格
- (void)editView:(GoodsEditView *)editView userInputResultForPriceWithinputStr:(NSString *_Nullable)inputStr {
    _goodsModel.sellprice = inputStr;
}

/// 选择是否包邮
- (void)editView:(GoodsEditView *)editView selecIstMail:(BOOL)isMail {
    _goodsModel.freeshipping = isMail;
}

/// 删除作品
- (void)editView:(GoodsEditView *)editView selecIstToDelete:(id)sender {
    [editView hide:^{
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"uid"] = [UserInfoManager shareManager].uid;
        params[@"good_id"] = [ToolUtil isEqualToNonNullKong:_goodsModel.ID];
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader deleteGoods] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            @weakify(self);
            [SVProgressHUD showSuccess:@"删除成功" completion:^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } fail:nil];
    }];
}

/// 确认修改
- (void)editView:(GoodsEditView *)editView selecIstToConfirm:(id)sender {
    if (editView.model.sellprice.doubleValue <= 0.00) {
        [SVProgressHUD showMsg:@"商品价格需大于0.00元"];
        return;
    }
    
    [editView hide:^{
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"uid"] = [UserInfoManager shareManager].uid;
        params[@"good_id"] = [ToolUtil isEqualToNonNullKong:_goodsModel.ID];
        params[@"good_sell_type"] = StringWithFormat(@(_goodsModel.good_sell_type));
        params[@"good_price"] = [ToolUtil isEqualToNonNullKong:_goodsModel.sellprice];
        params[@"gfreeshipping"] = StringWithFormat(@(_goodsModel.freeshipping));
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader editGoodsInfo] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            @weakify(self);
            [SVProgressHUD showSuccess:@"修改成功" completion:^{
                @strongify(self);
                [self loadData:nil];
            }];
        } fail:nil];
    }];
}

#pragma mark - GoodsIDCardViewDelegate
- (void)cardView:(GoodsIDCardView *)cardView clickToShare:(NSInteger)type withImage:(UIImage * _Nullable)image {
    [[WechatManager shareManager] wxSendImageWithScene:(AMShareViewItemStyle)type withImage:image];
}

- (void)cardView:(GoodsIDCardView *)cardView clickToSaveLocal:(UIImage * _Nullable)image {
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    NSString *msg = @"保存图片成功" ;;
    if(error != NULL) {
        msg = @"保存图片失败" ;
    }
    SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
    alertView.title = msg;
    alertView.needCancelShow = NO;
    [alertView show];
}

#pragma mark - GoodsPartWebDelegate
- (void)webCell:(GoodsPartWebTableCell *)webCell didFinishLoadWithScrollHeight:(CGFloat)scrollHeight {
    if (_webHeight != scrollHeight) {
        _webHeight = scrollHeight;
        [self.tableView reloadData];
    }
}

#pragma mark - Click
- (IBAction)clickToBuy:(id)sender {
    if ([ToolUtil isEqualOwner:_userModel.id]) {
        [SVProgressHUD showError:@"不能购买自己的商品"];
        return;
    }
    OrderFillViewController *orderVC = [[OrderFillViewController alloc] init];
    orderVC.goodsModel = _goodsModel;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)clickToHide:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToShare:(id) sender {
    AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleInvite];
    shareView.params = (NSDictionary *)[_goodPageData objectForKey:@"share"];
    [shareView show];
}

- (void)clickToShorIDCard:(id)sender {
    [[GoodsIDCardView shareInstance:_goodsModel.good_auth_image_path delegate:self] show];
}

- (void)clickToEdit:(id)sender {
    GoodsEditView *editView = [GoodsEditView shareInstance];
    editView.delegate = self;
    editView.model = _goodsModel;
    [editView show];
}

- (void)clickToShowHome:(id)sender {
//    CustomPersonalViewController *personalVC = [CustomPersonalViewController shareInstance];
//    personalVC.artuid = [ToolUtil isEqualToNonNullKong:[(NSDictionary *)[_goodPageData objectForKey:@"good_info"] objectForKey:@"guid"]];
//    [self.navigationController pushViewController:personalVC animated:YES];
    
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = [ToolUtil isEqualToNonNullKong:[(NSDictionary *)[_goodPageData objectForKey:@"good_info"] objectForKey:@"guid"]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (void)loadData:(id)sender {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"user_id"] = [UserInfoManager shareManager].uid;
    params[@"good_id"] = [ToolUtil isEqualToNonNullKong:_goodsID];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getGoodsDetailNew] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        if (_goodPageData.count) [_goodPageData removeAllObjects];
        _goodPageData = [[(NSDictionary *)response objectForKey:@"data"] mutableCopy];
        
        if (_goodPageData && _goodPageData.count) {
            _goodsModel = [VideoGoodsModel yy_modelWithJSON:[_goodPageData objectForKey:@"good_info"]];
            _userModel = [UserInfoModel yy_modelWithJSON:[_goodPageData objectForKey:@"user_info"]];
            
            _goodsModel.uname = _userModel.username;
        }
        
        self.goodsDetailModel = [GoodsDetailModel yy_modelWithDictionary:response[@"data"]];
        [self.goodsDetailModel.goodAtlas enumerateObjectsUsingBlock:^(GoodsAtlas * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:[ToolUtil getNetImageURLStringWith:obj.aimgsrc]];
            [self.imageUrls addObject:data];
        }];
        
        [self loadUIs];
    } fail:nil];
}

- (void)loadUIs {
    self.navigationItem.rightBarButtonItems = [self loadNaviItems];
    _btnCarrier.hidden = !_goodsModel.good_sell_type;
    if (!_btnCarrier.hidden) {
        self.buyBtn.enabled = !_goodsModel.status;
    }
    [self.tableView reloadData];
}

- (NSArray *)loadNaviItems {
    if (!_userModel) return @[];
    
    AMButton *shareBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    shareBtn.size = CGSizeMake(40.0f, 40.0f);
    [shareBtn setImage:ImageNamed(@"icon-navHead-share") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickToShare:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem =  [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    AMButton *idcardBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    idcardBtn.size = CGSizeMake(40.0f, 40.0f);
    [idcardBtn setImage:ImageNamed(@"goodsIDCard_Black") forState:UIControlStateNormal];
    [idcardBtn addTarget:self action:@selector(clickToShorIDCard:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *idcardItem =  [[UIBarButtonItem alloc] initWithCustomView:idcardBtn];
    
    if ([ToolUtil isEqualOwner:_userModel.id]) {
        AMButton *eidtBtn = [AMButton buttonWithType:UIButtonTypeCustom];
        eidtBtn.size = CGSizeMake(40.0f, 40.0f);
        [eidtBtn setImage:ImageNamed(@"goodsEdit_Black") forState:UIControlStateNormal];
        [eidtBtn addTarget:self action:@selector(clickToEdit:) forControlEvents:UIControlEventTouchUpInside];
        if (_goodsModel.good_sell_type && _goodsModel.status) {
            return @[shareItem, idcardItem];
        }else {
            UIBarButtonItem *eidtItem =  [[UIBarButtonItem alloc] initWithCustomView:eidtBtn];
            return @[shareItem, idcardItem, eidtItem];
        }
    }
    return @[shareItem,idcardItem];
}

//- (void)showImagePreview:(NSArray *)bannerArray index:(NSInteger)currentIndex {
//    NSMutableArray *previewArray = [NSMutableArray new];
//    [bannerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GQBaseImageVideoModel *model = [[GQBaseImageVideoModel alloc] init];
//        model.GQIsImageURL = YES;
//        model.GQURLString = obj;
//        model.GQImageViewClassName = @"GQBaseImageView";
//        [previewArray insertObject:model atIndex:previewArray.count];
//    }];
//    //基本调用
//    [GQImageVideoViewer sharedInstance].backgroundColor = Color_Black;
//    [GQImageVideoViewer sharedInstance].dataArray = previewArray;//这是图片和视频数组
//    [GQImageVideoViewer sharedInstance].usePageControl = NO;//设置是否使用pageControl
//    [GQImageVideoViewer sharedInstance].selectIndex = currentIndex;//设置选中的图片索引
//    [GQImageVideoViewer sharedInstance].achieveSelectIndex = ^(NSInteger selectIndex){
//        NSLog(@"achieveSelectIndex = %ld",selectIndex);
//    };//获取当前选中的图片索引
//    @weakify(self);
//    [GQImageVideoViewer sharedInstance].lpSelectImage = ^(UIImage *image) {
//        @strongify(self);
//        [self showAlertForSaveImage:image];
//    };
//    [GQImageVideoViewer sharedInstance].laucnDirection = GQLaunchDirectionBottom;//设置推出方向
//    [[GQImageVideoViewer sharedInstance] showInView:[UIApplication sharedApplication].keyWindow];//显示GQImageViewer到指定view上
//}
//
//- (void)showAlertForSaveImage:(UIImage *)image {
//    if (image) {
//        @weakify(self);
//        AMAlertView *alert = [AMAlertView shareInstanceWithTitle:@"是否保存当前图片?" buttonArray:@[@"是", @"否"] confirm:^{
//            PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
//            // 请求\检查访问权限 :
//            // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
//            // 如果之前已经做过选择，会直接执行block
//            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前App访问相册
//                        if (oldStatus != PHAuthorizationStatusNotDetermined) {
//                            [SVProgressHUD showError:@"无相册访问权限，请修改"];
//                        }
//                    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前App访问相册
//                        @strongify(self);
//                        [self saveImage:image];
//                    } else if (status == PHAuthorizationStatusRestricted) { // 无法访问相册
//                        [SVProgressHUD showError:@"因系统原因，无法访问相册"];
//                    }
//                });
//            }];
//        } cancel:nil];
//        [alert show];
//    }else {
//        [SVProgressHUD showMsg:@"当前图片为空，请重试"];
//    }
//}
//
//- (void)saveImage:(UIImage *)image {
//    [SVProgressHUD show];
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//        [SVProgressHUD dismiss];
//        if (error) {
//            [SVProgressHUD showError:@"保存失败！"];
//        } else {
//            [SVProgressHUD showSuccess:@"保存成功！"];
//        }
//    }];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
