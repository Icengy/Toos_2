//
//  StartupPageViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/2/25.
//  Copyright © 2020 lcy. All rights reserved.
//

#import "StartupPageViewController.h"

#import "MainTabBarController.h"
#import "AppDelegate.h"

#import "StartupPageCell.h"

@interface StartupPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet AMButton *startBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end

@implementation StartupPageViewController {
    NSMutableArray *_dataArray;
    NSInteger _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self jumpToTabbar];
//    return;
    
    if ([AMUserDefaults boolForKey:isFirstLaunchDefaults]) {
        [self jumpToTabbar];
        return;
    }else {
        _dataArray = [NSMutableArray new];
        for (int i = 0; i < 4; i ++) {
            [_dataArray insertObject:[NSString stringWithFormat:@"lead_page_0%@",@(i + 1)] atIndex:_dataArray.count];
        }
        
        self.startBtn.layer.cornerRadius = self.startBtn.height/2;
        self.startBtn.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:1];
        
        self.collectionView.hidden = NO;

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(K_Width, K_Height);
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView.collectionViewLayout = layout;
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StartupPageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([StartupPageCell class])];
        
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [self.collectionView reloadData];
        
        [self.view bringSubviewToFront:self.pageControl];
        [self.pageControl addTarget:self action:@selector(changePageWithControl:) forControlEvents:UIControlEventTouchUpInside];
        [self.view bringSubviewToFront:self.startBtn];
    }
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StartupPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([StartupPageCell class]) forIndexPath:indexPath];
    
    cell.showIV.image = ImageNamed(_dataArray[indexPath.item]);
    switch (indexPath.item) {
        case 0:
            cell.showIV.backgroundColor = [UIColor redColor];
            break;
        case 2:
            cell.showIV.backgroundColor = [UIColor blackColor];
            break;
            
        default:
            break;
    }
//    [cell.showBtn sd_setImageWithURL:_dataArray[indexPath.item] forState:UIControlStateNormal];
    cell.clickToTouchBlock = ^(BOOL isLeft) {
        [self changeContentOffsetWithTouch:isLeft];
    };
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = (NSInteger)scrollView.contentOffset.x/K_Width;
    self.pageControl.currentPage = _currentPage;
    if (_currentPage == _dataArray.count -1) {
        self.startBtn.hidden = NO;
    }else {
        self.startBtn.hidden = YES;
    }
}

- (void)changeContentOffsetWithTouch:(BOOL)isLeft {
    if (isLeft) {
        if (_currentPage == 0) return;
        _currentPage--;
    }else {
        if (_currentPage == _dataArray.count - 1) return;
        _currentPage ++;
    }
    self.pageControl.currentPage = _currentPage;
    if (_currentPage == _dataArray.count -1) {
        self.startBtn.hidden = NO;
    }else {
        self.startBtn.hidden = YES;
    }
    [self.collectionView setContentOffset:CGPointMake(K_Width *_currentPage, 0) animated:YES];
}

#pragma mark -
- (IBAction)clickToStart:(id)sender {
    [AMUserDefaults setBool:YES forKey:isFirstLaunchDefaults];
    [AMUserDefaults synchronize];
    [self jumpToTabbar];
}

- (void)changePageWithControl:(UIPageControl *)control {
    if (_currentPage == control.currentPage) return;
    
    _currentPage = control.currentPage;
    if (_currentPage == _dataArray.count -1) {
        self.startBtn.hidden = NO;
    }else {
        self.startBtn.hidden = YES;
    }
    [self.collectionView setContentOffset:CGPointMake(K_Width *_currentPage, 0) animated:YES];
}

- (void)jumpToTabbar {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = [[MainTabBarController alloc] init];
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
