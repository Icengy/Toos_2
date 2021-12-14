//
//  AMCertificateDetailViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCertificateDetailViewController.h"

#import "GoodsPartViewController.h"

#import "AMCertificateListCollectionCell.h"
#import "AMCertificateBtnCollectionCell.h"
#import "WaterCollectionViewFlowLayout.h"

#import "AMShareView.h"
#import "WechatManager.h"

@interface AMCertificateDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AMCertificateBtnCollectionCellDelegate, AMShareViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation AMCertificateDetailViewController

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _flowLayout.minimumInteritemSpacing = 15.0f; //行间距
        _flowLayout.minimumLineSpacing = 15.0f; //列间距
        _flowLayout.sectionInset = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        
//        _flowLayout.delegate = self;
        
    }return _flowLayout;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    self.navigationItem.title = @"权属证书";
    
    
    AMButton *artworksBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    [artworksBtn setTitle:@"查看作品" forState:UIControlStateNormal];
    [artworksBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    artworksBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    [artworksBtn addTarget:self action:@selector(clickToArtworks:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:artworksBtn];
    
    self.collectionView.collectionViewLayout = self.flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCertificateListCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMCertificateListCollectionCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCertificateBtnCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMCertificateBtnCollectionCell class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        AMCertificateListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMCertificateListCollectionCell class]) forIndexPath:indexPath];
            
        cell.model = self.model;
        return cell;
    }
    AMCertificateBtnCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMCertificateBtnCollectionCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = K_Width - self.flowLayout.sectionInset.right - self.flowLayout.sectionInset.left;
    if (indexPath.item) {
        if ([WXApi isWXAppInstalled]) {
            return CGSizeMake(width, 15.0f *3 +40.0f *2);
        }
        return CGSizeMake(width, 15.0f *2 +40.0f);
    }else {
        return CGSizeMake(width, width*(283.0f/167.0f));
    }
}

#pragma mark - AMCertificateBtnCollectionCellDelegate
- (void)btnCell:(AMCertificateBtnCollectionCell *)btnCell didSelectedForDownload:(id)sender {
    AMCertificateListCollectionCell *cell = (AMCertificateListCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (cell.cerImage) {
        UIImageWriteToSavedPhotosAlbum(cell.cerImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }else {
        [SVProgressHUD showError:@"数据错误，请联系客服或重试"];
    }
}

- (void)btnCell:(AMCertificateBtnCollectionCell *)btnCell didSelectedForShare:(id)sender {
    AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleImage];
    shareView.delegate = self;
    [shareView show];
}

#pragma mark -
- (void)shareView:(AMShareView *)shareView didSelectedWithItemStyle:(AMShareViewItemStyle)itemStyle {
    AMCertificateListCollectionCell *cell = (AMCertificateListCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (itemStyle == AMShareViewItemStyleSaveLocal) {
        [SVProgressHUD show];
        if (cell.cerImage) {
            UIImageWriteToSavedPhotosAlbum(cell.cerImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }else {
        [[WechatManager shareManager] wxSendImageWithScene:(AMShareViewItemStyle)itemStyle withImage:cell.cerImage];
    }
}

- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    [SVProgressHUD dismiss];
    NSString *msg = @"下载证书成功" ;;
    if(error != NULL) {
        msg = @"下载证书失败" ;
    }
    SingleAMAlertView *alertView = [SingleAMAlertView shareInstance];
    alertView.title = msg;
    alertView.needCancelShow = NO;
    [alertView show];
}


#pragma mark -
- (void)clickToArtworks:(id)sender {
    GoodsPartViewController *partViewController = [[GoodsPartViewController alloc] init];
    partViewController.goodsID = [ToolUtil isEqualToNonNullKong:self.model.goodId];
    [self.navigationController pushViewController:partViewController animated:YES];
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
