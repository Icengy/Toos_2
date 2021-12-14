//
//  AMCoursePublishViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCoursePublishViewController.h"
#import "ArtistClassListController.h"
#import "HomeBaseViewController.h"
#import "ClassDetailViewController.h"

#import "AMCoursePublishResultTableCell.h"
#import "AMCoursePublishInfoTableCell.h"

#import "AMCourseModel.h"

@interface AMCoursePublishViewController () <UITableViewDelegate ,UITableViewDataSource ,AMCoursePublishResultDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AMCoursePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removePreviousViewController:[ClassDetailViewController class]];
    self.navigationItem.leftBarButtonItem = nil;
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCoursePublishResultTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMCoursePublishResultTableCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCoursePublishInfoTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMCoursePublishInfoTableCell class])];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"发布结果";
    
    [self loadData:nil];
}

#pragma mark - UITableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.success?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        AMCoursePublishInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMCoursePublishInfoTableCell class]) forIndexPath:indexPath];
        
        cell.model = self.model;
        return cell;
    }else {
        AMCoursePublishResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMCoursePublishResultTableCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.success = self.success;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)loadData:(id)sende {

    [ApiUtil getWithParent:self url:[ApiUtilHeader getSingleLiveCourseDetail:self.model.courseId] params:nil success:^(NSInteger code, id  _Nullable response) {
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.model = [AMCourseModel yy_modelWithDictionary:data];
            
            [self.tableView reloadData];
        }
    } fail:nil];
}

#pragma mark - AMCoursePublishResultDelegate
- (void)resultCell:(AMCoursePublishResultTableCell *)resultCell didSelectedWithSuccess:(id)sender{
  
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)resultCell:(AMCoursePublishResultTableCell *)resultCell didSelectedWithFail:(id)sender{
    NSLog(@"失败");
        [self.navigationController popViewControllerAnimated:YES];
}


//禁用滑动返回
- (void)viewDidAppear:(BOOL)animated {
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}
@end
