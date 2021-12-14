//
//  AMCourseAddChaptersViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseAddChaptersViewController.h"
#import "AMCourseChapterCreateViewController.h"
#import "AMCourseChaptersViewController.h"
#import "AMCoursePublishViewController.h"
#import "AMCourseNewViewController.h"

#import "AMCourseModel.h"
#import "AMCourseChapterModel.h"

#import "AMCourseCoverCell.h"
#import "AMCourseIntroCell.h"
#import "EmptyTableViewCell.h"

#define CustomeItemContentSectionHeight  (K_Height - StatusNav_Height - 60.5f - SafeAreaBottomHeight)

@interface AMCourseAddChaptersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet AMButton *saveSortBtn;
@property (weak, nonatomic) IBOutlet AMButton *addChaptersBtn;

@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet AMButton *sortBtn;
@property (weak, nonatomic) IBOutlet AMButton *addChaptersBtn2;


@property (nonatomic, strong) NSMutableArray <AMCourseChapterModel *>*dataArray;
@property (nonatomic, assign) BOOL isSorting;
@property (nonatomic, strong) AMCourseChaptersViewController *chaptersViewController;

@end

@implementation AMCourseAddChaptersViewController

- (AMButton *)rightBtn {
    AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 52.0f, 26.0f);
    
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color_Whiter forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xDB1111)] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    
    rightBtn.layer.cornerRadius = 13.0f;
    rightBtn.clipsToBounds = YES;
    
    [rightBtn addTarget:self action:@selector(clickToPublish:) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

- (NSMutableArray <AMCourseChapterModel *>*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }return _dataArray;
}

- (AMCourseChaptersViewController *)chaptersViewController {
    if (!_chaptersViewController) {
        _chaptersViewController = [[AMCourseChaptersViewController alloc] init];
        _chaptersViewController.delegate = self;
        @weakify(self);
        _chaptersViewController.clickToReloadBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self loadData:nil];
            });
        };
        _chaptersViewController.courseModel = self.model;
    }return _chaptersViewController;
}


- (instancetype) init {
    if (self = [super init]) {
        self.addChaptersBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
        self.addChaptersBtn2.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
        self.sortBtn.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    }return self;
}


- (void)removePreviousViewController{
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            for (UIViewController *vc in vcArr) {
                if ([vc isKindOfClass:[AMCourseNewViewController class]]) {
                    [vcArr removeObject:vc];
                    break;
                }
            }
     self.navigationController.viewControllers = vcArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self removePreviousViewController];
    // Do any additional setup after loading the view from its nib.
    
    self.canScroll = YES;
    
    self.contentChildArray = @[self.chaptersViewController].mutableCopy;
    self.contentCarrier.dataSource = self;
    [self addChildViewController:self.contentCarrier];
    
    self.tableView.multipleGestureEnable = YES;
    self.tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCourseCoverCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMCourseCoverCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCourseIntroCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMCourseIntroCell class])];
    [self.tableView registerClass:[EmptyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EmptyTableViewCell class])];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"创建直播课";
    
    [self loadData:nil];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) return CustomeItemContentSectionHeight;
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AMCourseCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMCourseCoverCell class]) forIndexPath:indexPath];

        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1) {
        AMCourseIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMCourseIntroCell class]) forIndexPath:indexPath];

        cell.model = self.model;
        return cell;
    }
    EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptyTableViewCell class]) forIndexPath:indexPath];
    
    cell.contentCarrier = self.contentCarrier.view;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (NSInteger)numberOfControllersInPagerController {
    return self.contentChildArray.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index {
    return @"";
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index {
    return self.contentChildArray[index];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dataArray.count) {
        CGFloat bottomCellOffset = [self.tableView rectForSection:self.tableView.numberOfSections - 1].origin.y;
        [self tableViewDidScroll:scrollView bottomCellOffset:bottomCellOffset];
    }else {
        if (!self.canScroll) [self tableViewScrollToTopOffset];
    }
}

#pragma mark - BaseItemViewController
- (void)itemListController:(BaseItemViewController *)listVC scrollToTopOffset:(BOOL)scrollTop {
    [self tableViewScrollToTopOffset];
}

#pragma mark -
- (void)clickToPublish:(AMButton *)sender {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"courseId"] = self.model.courseId;
    [ApiUtil postWithParent:self url:[ApiUtilHeader publishLiveCourse] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        AMCoursePublishViewController *publish = [[AMCoursePublishViewController alloc] init];
        publish.success = YES;
        publish.model = self.model;
        [self.navigationController pushViewController:publish animated:YES];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        AMCoursePublishViewController *publish = [[AMCoursePublishViewController alloc] init];
        publish.success = NO;
        [self.navigationController pushViewController:publish animated:YES];
    }];
    
}

- (IBAction)clickToSaveSort:(id)sender {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableArray *sortArray = @[].mutableCopy;
    [self.dataArray enumerateObjectsUsingBlock:^(AMCourseChapterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *sort = @{}.mutableCopy;
        sort[@"chapterSort"] = @(idx + 1);
        sort[@"chapterId"] = obj.chapterId;
        [sortArray addObject:sort.copy];
    }];
    params[@"chapterList"] = sortArray.copy;
    params[@"courseId"] = self.model.courseId;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader updateLiveCourseChapterSort] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [SVProgressHUD showSuccess:[response objectForKey:@""] completion:^{
            self.isSorting = NO;
            [self.dataArray enumerateObjectsUsingBlock:^(AMCourseChapterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.chapterSort = [NSString stringWithFormat:@"%@",@(idx+1)];
                [self.dataArray replaceObjectAtIndex:idx withObject:obj];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.chaptersViewController.dataArray = self.dataArray;
                [self.chaptersViewController.tableView setEditing:self.isSorting animated:YES];
                [self updateBottom];
            });

        }];
    } fail:nil];

}

- (IBAction)clickToSort:(id)sender {
    self.isSorting = YES;
    
    [self.chaptersViewController.tableView setEditing:self.isSorting animated:YES];
    
    [self updateBottom];
}

- (IBAction)clickToAddChapter:(id)sender {
    AMCourseChapterCreateViewController *chapterVC = [[AMCourseChapterCreateViewController alloc] init];
    AMCourseChapterModel *model = [AMCourseChapterModel new];
    model.chapterSort = StringWithFormat(@(self.dataArray.count+1));
    model.isFree = self.model.isFree;
    chapterVC.model = model;
    chapterVC.courseModel = self.model;
    chapterVC.courseIsFree = self.model.isFree;
    chapterVC.isEditChapter = NO;
    @weakify(self);
    chapterVC.clickToAddBlock = ^(AMCourseChapterModel * _Nonnull model) {
        @strongify(self);
        [self addNewChapter:model];
    };

    [self.navigationController presentViewController:chapterVC animated:YES completion:nil];
}

#pragma mark -
- (void)updateBottom {
    if (self.dataArray.count) {
        //发布状态 1:已发布;2:未发布'
        if ([self.model.publishStatus isEqualToString:@"2"]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBtn]];
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.chaptersViewController.tableView.scrollEnabled = !self.isSorting;
    self.tableView.scrollEnabled = !self.isSorting;
    
    self.saveSortBtn.hidden = !self.isSorting;
    self.addChaptersBtn.hidden = self.isSorting;
    self.sortView.hidden = self.isSorting;
    if (!self.isSorting) {
        self.addChaptersBtn.hidden = self.dataArray.count;
        self.sortView.hidden = !self.dataArray.count;
    }
}

- (void)addNewChapter:(AMCourseChapterModel *)model {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"courseId"] = self.model.courseId;
    params[@"chapterSort"] = model.chapterSort;
    params[@"chapterTitle"] = model.chapterTitle;
    params[@"isFree"] = model.isFree;
    params[@"liveStartTime"] = [NSString stringWithFormat:@"%@:00",model.liveStartTime];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader addLiveCourseChapter] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        
        [self loadData:nil];
    } fail:nil];
}


- (void)loadData:(id)sender {

    [ApiUtil getWithParent:self url:[ApiUtilHeader getLiveCourseDetail:self.model.courseId] params:nil success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.model = [AMCourseModel yy_modelWithDictionary:data];
            self.dataArray = self.model.courseChapters.mutableCopy;
            self.chaptersViewController.dataArray = self.dataArray;
            
            [self updateBottom];
            [self.tableView reloadData];
        }
    } fail:nil];
}


@end
