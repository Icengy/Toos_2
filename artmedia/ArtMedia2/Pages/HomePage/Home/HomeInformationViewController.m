//
//  HomeInformationViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/2/25.
//  Copyright © 2020 lcy. All rights reserved.
//

#import "HomeInformationViewController.h"
#import "HomeInformationDetailViewController.h"

#import "TYTabButtonPagerController.h"

#import "AMEmptyView.h"


@interface HomeInformationViewController ()<TYPagerControllerDataSource>

@property (strong, nonatomic) TYTabButtonPagerController *contentView;
@property (nonatomic ,strong) NSMutableArray *contentChildArray;
@property (nonatomic ,strong) NSMutableArray *contentTitleArray;

@end

@implementation HomeInformationViewController {
    NSMutableArray *_dataArray;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray new];
    _contentChildArray = [NSMutableArray new];
    _contentTitleArray = [NSMutableArray new];
    
    [self addChildViewController:self.contentView];
    [self.view addSubview:self.contentView.view];
    
    self.view.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
    [self.view ly_showEmptyView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_dataArray.count)
        [self loadData:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.contentView.view.frame = CGRectMake(0, 0, self.view.width, self.view.height - TabBar_Height);
}

#pragma mark -
- (NSArray *)getContentChildArray {
    NSMutableArray *childArray = [NSMutableArray new];
    
    for (int i = 0; i < _dataArray.count; i ++) {
        HomeInformationDetailViewController *detailVC = [[HomeInformationDetailViewController alloc] init];
        detailVC.detailTypeID = [_dataArray[i] objectForKey:@"id"];
        detailVC.detailType = [_dataArray[i] objectForKey:@"tname"];
        [childArray addObject:detailVC];
    }
    
    return childArray;
}

- (NSArray *)getContentTitleArray {
    NSMutableArray *childArray = [NSMutableArray new];
    
    for (int i = 0; i < _dataArray.count; i ++) {
        [childArray addObject:[_dataArray[i] objectForKey:@"tname"]];
    }
    
    return childArray;
}

#pragma mark -
#pragma mark -- TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return _contentTitleArray[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return _contentChildArray[index];
}

#pragma mark -
- (TYTabButtonPagerController *)contentView {
    if (!_contentView) {
        _contentView = [[TYTabButtonPagerController alloc] init];
        
        _contentView.dataSource = self;
        _contentView.barStyle = TYPagerBarStyleCoverView;
        _contentView.customShadowColor = [UIColor clearColor];
        _contentView.contentTopEdging = NavBar_Height;
        _contentView.collectionLayoutEdging = ADAptationMargin;
        
        _contentView.cellSpacing = ADAptationMargin;
        
        _contentView.normalTextFont = [UIFont addHanSanSC:13.0f fontType:0];
        _contentView.selectedTextFont = [UIFont addHanSanSC:13.0f fontType:0];
        
        _contentView.progressColor = RGBA(249, 110, 34, 0.1f);
        _contentView.normalTextColor = RGB(157, 161, 179);
        _contentView.selectedTextColor = RGB(249, 110, 34);
        
    } return _contentView;
}


#pragma mark -
- (void)loadData:(id _Nullable)sender {
    if (_dataArray.count) [_dataArray removeAllObjects];
    
//    [ApiUtil post:[ApiUtilHeader getInfoTypeList] needHUD:NO needTips:NO params:nil success:^(id response) {
//        [self.view ly_hideEmptyView];
//        if ([response[@"code"] integerValue] == 0) {
//            NSArray *array = (NSArray *)response[@"data"];
//            if (array.count) {
//                [_dataArray addObjectsFromArray:array];
//                
//                if (_contentTitleArray.count) [_contentTitleArray removeAllObjects];
//                if (_contentChildArray.count) [_contentChildArray removeAllObjects];
//                
//                [_contentTitleArray addObjectsFromArray:[self getContentTitleArray]];
//                [_contentChildArray addObjectsFromArray:[self getContentChildArray]];
//                
//                if (_dataArray.count > 4) {
//                    _contentView.cellWidth = (K_Width-ADAptationMargin * 5)/4;
//                }else if (_dataArray.count > 0){
//                    _contentView.cellWidth = (K_Width-ADAptationMargin*(_contentChildArray.count+1))/_contentChildArray.count;
//                }
//                [self.contentView reloadData];
//            }
//        }
//    } fail:^(NSError * _Nullable error) {
//    }];
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
