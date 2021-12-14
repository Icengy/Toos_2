//
//  AMCertificateNonAuthedViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCertificateNonAuthedViewController.h"
#import "GoodsPartViewController.h"
#import "PhoneAuthViewController.h"
#import "FaceRecognitionViewController.h"

#import "WaterCollectionViewFlowLayout.h"
#import "AMCerNonDataCollectionCell.h"

#import "AMDialogView.h"

#import "VideoGoodsModel.h"

@interface AMCertificateNonAuthedViewController () <WaterCollectionViewFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *nonDataView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet AMButton *authBtn;


@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *tips_data_Label;
@property (weak, nonatomic) IBOutlet AMButton *data_authBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong) WaterCollectionViewFlowLayout *waterFlowLayout;

@end

@implementation AMCertificateNonAuthedViewController {
    NSMutableArray <VideoGoodsModel *>*_dataArray;
}

- (WaterCollectionViewFlowLayout *)waterFlowLayout {
    if (!_waterFlowLayout) {
        _waterFlowLayout = [[WaterCollectionViewFlowLayout alloc] init];
        
        _waterFlowLayout.minimumInteritemSpacing = 15.0f; //行间距
        _waterFlowLayout.minimumLineSpacing = 15.0f; //列间距
        _waterFlowLayout.sectionInset = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        
        _waterFlowLayout.delegate = self;
        
    }return _waterFlowLayout;
}

- (instancetype)init {
    if (self = [super init]) {
        _dataArray = @[].mutableCopy;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.tipsLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    self.authBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
    
    self.dataLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    self.tipsLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    self.data_authBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    self.collectionView.collectionViewLayout = self.waterFlowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCerNonDataCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMCerNonDataCollectionCell class])];
    [self.collectionView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_dataArray.count) [self loadData:nil];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMCerNonDataCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMCerNonDataCollectionCell class]) forIndexPath:indexPath];
        
    if (_dataArray.count) cell.model = _dataArray[indexPath.item];
        
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AMCerNonDataCollectionCell *cell = (AMCerNonDataCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    GoodsPartViewController *detailVC = [[GoodsPartViewController alloc] init];
    detailVC.goodsID = cell.model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGSize)flowLayout:(WaterCollectionViewFlowLayout *)flowLayout heightForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = (K_Width - 15.0f*3)/2;
    return CGSizeMake(width, width*(297.0f/167.0f));
}

#pragma mark -
- (IBAction)clickToAuth:(id)sender {
//    AMAuthDialogView *dialogView = [AMAuthDialogView shareInstance];
//    @weakify(dialogView);
//    dialogView.imageSelectedBlock = ^(AMImageSelectedMeidaType meidaType) {
//        @strongify(dialogView);
//        [dialogView hide];
//        if (meidaType) {
//            [self.navigationController pushViewController:[[PhoneAuthViewController alloc] init] animated:YES];
//        }else {
//            [self.navigationController pushViewController:[[FaceRecognitionViewController alloc] init] animated:YES];
//        }
//    };
//    [dialogView show];
    [self.navigationController pushViewController:[[FaceRecognitionViewController alloc] init] animated:YES];
}


- (void)loadData:(id _Nullable)sender {
    self.collectionView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (![sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        if (_dataArray.count) [_dataArray removeAllObjects];
    }
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectWaitAuthGoodsList] params:@{@"user_id":[UserInfoManager shareManager].uid} success:^(NSInteger code, id  _Nullable response) {
        [self.collectionView endAllFreshing];
        NSDictionary *data =(NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {

            [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VideoGoodsModel class] json:data]];
        }
        if (_dataArray.count) {
            self.nonDataView.hidden = YES;
            self.dataView.hidden = NO;
            [self.collectionView reloadData];
            
            _dataLabel.text = [NSString stringWithFormat:@"共有%@件作品可获得权属证书", @(_dataArray.count)];
        }else {
            self.nonDataView.hidden = NO;
            self.dataView.hidden = YES;
        }
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.collectionView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
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
