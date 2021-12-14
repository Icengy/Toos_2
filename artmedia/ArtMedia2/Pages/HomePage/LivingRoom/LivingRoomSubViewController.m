//
//  LivingRoomSubViewController.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/1.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "LivingRoomSubViewController.h"
#import "AMBaseUserHomepageViewController.h"

#import "LivingRoomCell.h"

#import "LivingRoomModel.h"

#import "FillLogisticsViewController.h"

@interface LivingRoomSubViewController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong , nonatomic) NSMutableArray <LivingRoomModel *>*dataArray;

@property (weak, nonatomic) IBOutlet UILabel *titlleLabel;
@property (weak, nonatomic) IBOutlet AMTextField *inputTF;
@property (copy , nonatomic) NSString *inputStr;

@end

@implementation LivingRoomSubViewController

- (UIView *)rightView {
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35.0f, 30.0f)];
    UIImageView *rightView = [[UIImageView alloc] initWithImage:ImageNamed(@"tab_search")];
    rightView.frame = CGRectMake(0, 0, 25.0f, 25.0f);
    rightView.centerY = wrapView.centerY;
    [wrapView addSubview:rightView];
    
    return wrapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.dataArray = @[].mutableCopy;
    self.titlleLabel.font = [UIFont addHanSanSC:15.0f fontType:1];
    
    [self updateTFUIs];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(K_Width/3, K_Width/3);
    flowLayout.minimumLineSpacing = CGFLOAT_MIN;
    flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
    
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LivingRoomCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([LivingRoomCell class])];
    
    [self.collectionView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    [self.collectionView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.collectionView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.dataArray.count) [self loadData:nil];
}

- (void)updateTFUIs {
    self.inputTF.text = self.inputStr;
    self.inputTF.rightViewMode = UITextFieldViewModeAlways;
    self.inputTF.rightView = [self rightView];
    self.inputTF.delegate = self;
    switch (self.utype.integerValue) {
        case 0: {/// 全部
            self.titlleLabel.text = @"全部会客厅";
            self.inputTF.placeholder = @"搜索感兴趣的会客厅";
            break;
        }
        case 3: {/// 全部
            self.titlleLabel.text = @"艺术家的会客厅";
            self.inputTF.placeholder = @"搜索艺术家";
            break;
        }
        case 4: {/// 全部
            self.titlleLabel.text = @"影视明星的会客厅";
            self.inputTF.placeholder = @"搜索影视明星";
            break;
        }
        case 5: {/// 全部
            self.titlleLabel.text = @"歌手的会客厅";
            self.inputTF.placeholder = @"搜索歌手";
            break;
        }
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.collectionView.userInteractionEnabled = NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.collectionView.userInteractionEnabled = YES;
    if (textField.text.length > 0) {
        self.inputStr = textField.text;
    }else{
        self.inputStr = nil;
    }
    [self loadData:nil];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AMBaseUserHomepageViewController * vc = [[AMBaseUserHomepageViewController alloc] init];
    vc.artuid = self.dataArray[indexPath.row].artistId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LivingRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LivingRoomCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

#pragma mark -
- (void)reloadCurrent:(NSNotification *)notification {
    [self loadData:notification];
}

- (void)loadData:(id)sender {
    self.collectionView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender && [sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        self.pageIndex ++;
    }else {
        self.pageIndex = 1;
        if (self.dataArray.count) [self.dataArray removeAllObjects];
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"current"] = @(self.pageIndex);
    param[@"artistName"] = [ToolUtil isEqualToNonNullKong:self.inputStr];
    param[@"utype"] = [ToolUtil isEqualToNonNull:self.utype replace:@"0"];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader huiketing] params:param.copy success:^(NSInteger code, id  _Nullable response) {
        [self.collectionView endAllFreshing];
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            NSArray *records = (NSArray *)[data objectForKey:@"records"];
            if (records && records.count) {
                [self.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[LivingRoomModel class] json:records]];
            }
            [self.collectionView updataFreshFooter:(self.dataArray.count && records.count != 15)];
        }
        [self.collectionView ly_updataEmptyView:!self.dataArray.count];
        self.collectionView.mj_footer.hidden = !self.dataArray.count;
        if ([sender isKindOfClass:[NSNotification class]]) {
            self.collectionView.contentOffset = CGPointMake(0, 0);
        }
        [self.collectionView reloadData];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.collectionView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
     }];
}

@end
