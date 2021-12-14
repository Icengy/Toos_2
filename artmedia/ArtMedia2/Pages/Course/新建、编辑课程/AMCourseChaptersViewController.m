//
//  AMCourseChaptersViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/19.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseChaptersViewController.h"

#import "AMCourseChapterCell.h"
#import "AMCourseChapterHeaderView.h"

#import "AMCourseChapterModel.h"

#import "AMEmptyView.h"

#import "AMCourseChapterCreateViewController.h"

@interface AMCourseChaptersViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, AMCourseChapterDelegate>
@property (nonatomic ,strong) AMCourseChapterHeaderView *headerView;
@end

@implementation AMCourseChaptersViewController

- (AMCourseChapterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [AMCourseChapterHeaderView shareInstance];
    }return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    self.vcCanScroll = YES;
    
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCourseChapterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMCourseChapterCell class])];
    
//    self.tableView.ly_emptyView = [AMEmptyView am_EmptyView];
}

- (UIScrollView *)scrollView {
    return self.tableView;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    
//    [self.tableView ly_updataEmptyView:!_dataArray.count];
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMCourseChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMCourseChapterCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.courseModel = self.courseModel;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count) return 44.0f;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count) {
        self.headerView.frame = CGRectMake(0, 0, tableView.width, 44.0f);
        self.headerView.chapters = self.dataArray.count;
        return self.headerView;
    }
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

#pragma mark - 排序，设置为UITableViewCellEditingStyleNone
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

//编辑状态下，只要实现这个方法，就能实现拖动排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 取出要拖动的模型数据
    AMCourseChapterModel *model = [self.dataArray objectAtIndex:sourceIndexPath.row];
    //删除之前行的数据
    [self.dataArray removeObject:model];
    // 插入数据到新的位置
    [self.dataArray insertObject:model atIndex:destinationIndexPath.row];
}

#pragma mark -- UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemListController:scrollToTopOffset:)])
            [self.delegate itemListController:self scrollToTopOffset:YES];
    }
    self.tableView.showsVerticalScrollIndicator = self.vcCanScroll;
}

#pragma mark - AMCourseChapterDelegate
- (void)chapterCell:(AMCourseChapterCell *)chapterCell didSelectedDelete:(id)sender {
    if (self.tableView.editing) return;
    
    if ([self.dataArray containsObject:chapterCell.model]) {
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"courseId"] = chapterCell.model.courseId;
        params[@"chapterId"] = chapterCell.model.chapterId;
        
        [ApiUtil postWithParent:self url:[ApiUtilHeader deleteLiveCourseChapter] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            [self.dataArray removeObject:chapterCell.model];
            [self.tableView reloadData];
            
            if (self.clickToReloadBlock) self.clickToReloadBlock();
        } fail:nil];
    }
}

- (void)chapterCell:(AMCourseChapterCell *)chapterCell didSelectedEdit:(id)sender {
    if (self.tableView.editing) return;
    
    AMCourseChapterCreateViewController *createVC = [[AMCourseChapterCreateViewController alloc] init];
    createVC.model = chapterCell.model;
    createVC.courseModel = self.courseModel;
    createVC.isEditChapter = YES;
    createVC.courseIsFree = self.courseModel.isFree;
    @weakify(self);
    createVC.clickToEditBlock = ^(AMCourseChapterModel * _Nonnull model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            NSIndexPath *indexPath = [self.tableView indexPathForCell:chapterCell];
            [self editChapter:model atIndexPath:indexPath];
        });
    };
    [self.navigationController presentViewController:createVC animated:YES completion:nil];
}

- (void)editChapter:(AMCourseChapterModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"courseId"] = model.courseId;
    params[@"chapterId"] = model.chapterId;
    params[@"chapterTitle"] = model.chapterTitle;
    params[@"liveStartTime"] = model.liveStartTime;
    params[@"isFree"] = model.isFree;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader updateLiveCourseChapter] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadData];
        
        if (self.clickToReloadBlock) self.clickToReloadBlock();
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
