//
//  AMCourseVideoListController.m
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseVideoListController.h"
#import "VideoListCell.h"
#import "VideoListHeadView.h"


@interface AMCourseVideoListController ()<UITableViewDelegate , UITableViewDataSource ,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AMCourseVideoListController
- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//        [self.view addGestureRecognizer:tap];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self setTableView];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableView]) {//屏蔽父视图在子视图手势
        return NO;
    }

    return YES;
}


- (void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoListCell class])];
    [self.tableView reloadData];
}
- (void)hide{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)showWithController:(UIViewController *)controller{

    [controller.navigationController presentViewController:self animated:YES completion:nil];
}


#pragma mark - UITabBarDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoListCell class]) forIndexPath:indexPath];
    cell.courseModel = self.courseModel;
    cell.model = self.courseModel.courseChapters[indexPath.row];
    cell.chapterId = self.chapterModel.chapterId;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    VideoListHeadView *view = [VideoListHeadView share];
    view.hideListBlock = ^{
        [self hide];
    };
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseModel.courseChapters.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AMCourseChapterModel *model = self.courseModel.courseChapters[indexPath.row];
    if ([model.isFree isEqualToString:@"1"]) {
        if ([self.delegate respondsToSelector:@selector(videoListSelect:indexPath:model:)]) {
            [self.delegate videoListSelect:tableView indexPath:indexPath model:self.courseModel.courseChapters[indexPath.row]];
        }
        [self hide];
    }else{//收费
        if ([self.courseModel.isBuy isEqualToString:@"1"] ) {
            if ([self.delegate respondsToSelector:@selector(videoListSelect:indexPath:model:)]) {
                [self.delegate videoListSelect:tableView indexPath:indexPath model:self.courseModel.courseChapters[indexPath.row]];
            }
            [self hide];
        }else{
            [SVProgressHUD showError:@"请先加入课程！"];
        }
    }

}







@end
