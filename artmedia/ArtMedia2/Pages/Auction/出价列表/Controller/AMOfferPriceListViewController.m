//
//  AMOfferPriceListViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMOfferPriceListViewController.h"
#import "AMOfferPriceListCollectionCell.h"
#import "NextTwentyOfferPriceModel.h"

@interface AMOfferPriceListViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nextPriceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (nonatomic , strong) NextTwentyOfferPriceModel *nextTwentyOfferPriceModel;
@property (nonatomic , copy) NSString *price;
@property (nonatomic , strong) NSMutableArray <NSString *>*priceListData;

@end

@implementation AMOfferPriceListViewController
- (NSMutableArray *)priceListData{
    if (!_priceListData) {
        _priceListData = [[NSMutableArray alloc] init];
    }
    return _priceListData;
}
- (IBAction)sureClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(priceListOfferPrice:)]) {
        [self.delegate priceListOfferPrice:self.price];
    }
    [self hide];
}

- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];

    }
    return self;
}
- (void)setCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake((self.collectionView.width )/2, 40);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMOfferPriceListCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMOfferPriceListCollectionCell class])];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollectionView];
    
    
}


- (void)setAuctionGoodId:(NSString *)auctionGoodId{
    _auctionGoodId = auctionGoodId;
    [self selectNextOfferPriceListByAuctionGoodId];
}

- (void)selectNextOfferPriceListByAuctionGoodId{
    NSLog(@"%@",self.auctionGoodId);
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectNextOfferPriceListByAuctionGoodId:self.auctionGoodId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        if (response) {
            self.nextTwentyOfferPriceModel = [NextTwentyOfferPriceModel yy_modelWithDictionary:response[@"data"]];
            [self.nextTwentyOfferPriceModel.nextOfferPriceList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.priceListData addObject:obj.description];
            }];
            self.price = self.priceListData[0];
        }
        [self.collectionView reloadData];
    } fail:nil];
}
- (void)setPrice:(NSString *)price{
    _price = price;
    self.nextPriceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolUtil stringToDealMoneyString:price]];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
   
    self.collectionViewHeight.constant = self.collectionView.contentSize.height;
}
- (void)hide{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeClick:(UIButton *)sender {
    [self hide];
}


- (void)showWithController:(UIViewController *)controller{
   
    [controller.navigationController presentViewController:self animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AMOfferPriceListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMOfferPriceListCollectionCell class]) forIndexPath:indexPath];
    if (self.priceListData.count) {
        cell.price = self.priceListData[indexPath.row];
    }
    
    cell.selectPrice = self.price;
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.price = self.priceListData[indexPath.row];
    [collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

@end
