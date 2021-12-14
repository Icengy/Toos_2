//
//  ClassDetailViewController.m
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "AMCourseChapterCreateViewController.h"
#import "VideoReplayListViewController.h"
#import "AMLivePushViewController.h"
#import "AMLivePlayViewController.h"
#import "ECoinRechargeViewController.h"
#import "AMCourseNewViewController.h"
#import "AMCoursePublishViewController.h"
#import "AMBaseUserHomepageViewController.h"
#import "AMLivePlayViewController.h"
#import "AMCourseVideoReplayController.h"

#import "ClassDetailHeadImageCell.h"
#import "ClassDetailTextCell.h"
#import "ClassDetailClassCell.h"
#import "ClassDetailArtistCell.h"
#import "ClassDetailClassHeadView.h"
#import "ClassDetailTeacherClassCell.h"

#import "JoinClassActionSheetView.h"
#import "JoinClassResultViewVontroller.h"
#import "FKAlertController.h"
#import "AMShareView.h"
#import "AMPayManager.h"

#import "ECoinModel.h"
#import "AMCourseModel.h"
#import "CustomPersonalModel.h"
//#import "AMCourseChapterModel.h"

@interface ClassDetailViewController ()<UITableViewDelegate , UITableViewDataSource , ClassDetailTeacherClassCellDelegate ,AMShareViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *reviewStatusView;
@property (weak, nonatomic) IBOutlet UILabel *reviewFailReasonLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *joinStudyView;//加入学习
@property (weak, nonatomic) IBOutlet UIView *teacherBottomView;//课时新增，排序
@property (weak, nonatomic) IBOutlet UIView *sortBackView;//保存排序按钮的背景图
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *addChapterButton;//添加新课时按钮
@property (weak, nonatomic) IBOutlet UIButton *finishChapterButton;//结束课时按钮

@property (nonatomic , strong) AMCourseModel *courseModel;//课程model
@property (nonatomic , strong) NSMutableArray <AMCourseChapterModel *>*courseChapters;//课时排序用，所以单独拎出来
@property (nonatomic , strong) ECoinModel *ecoinModel;
@property (nonatomic , strong) CustomPersonalModel *userModel;

@property (nonatomic , assign) BOOL isSort;//判断是否排序了
@end

@implementation ClassDetailViewController
- (NSMutableArray *)courseChapters{
    if (!_courseChapters) {
        _courseChapters = [[NSMutableArray alloc] init];
    }
    return _courseChapters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setButtonStatusTint];
    [self removePreviousViewController];
    self.isSort = NO;
    self.sortBackView.hidden = YES;
    [self setTableView];
    
}

- (void)setButtonStatusTint{
    [self.sortButton setTitleColor:RGB(179, 179, 179) forState:UIControlStateDisabled];
    [self.sortButton setImage:[UIImage imageNamed:@"course_sort_dis"] forState:UIControlStateDisabled];
    
    [self.finishChapterButton setTitleColor:RGB(179, 179, 179) forState:UIControlStateDisabled];
    [self.finishChapterButton setImage:[UIImage imageNamed:@"course_finish_dis"] forState:UIControlStateDisabled];
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


- (AMButton *)rightBtn {
    AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 52.0f, 26.0f);
    
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:Color_Whiter forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xDB1111)] forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    
    rightBtn.layer.cornerRadius = 13.0f;
    rightBtn.clipsToBounds = YES;
    
    [rightBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

- (AMButton *)shareButton {
    AMButton *rightBtn = [AMButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setImage:[UIImage imageNamed:@"icon-navHead-share"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
#pragma mark - 分享
- (void)share{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"des"] = self.courseModel.course_description;
    dic[@"img"] = [NSString stringWithFormat:@"%@/%@", IMAGE_JAVA_HOST ,self.courseModel.coverImage];
    dic[@"title"] = self.courseModel.courseTitle ;
    dic[@"url"] = [ApiUtilHeader shareCourseDetailURL:self.courseModel.courseId];
    
    AMShareView *shareView = [AMShareView shareInstanceWithStyle:AMShareViewStyleInvite];
    shareView.delegate = self;
    shareView.params = dic;
    [shareView show];
}

#pragma mark - IBAction UIButttonClick
//加入学习
- (IBAction)joinStudy:(UIButton *)sender {
    [ApiUtil getWithParent:self url:[ApiUtilHeader selectUserWalletByUserId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        self.ecoinModel = [ECoinModel yy_modelWithDictionary:response[@"data"]];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {

    }];
}
- (void)setEcoinModel:(ECoinModel *)ecoinModel{
    _ecoinModel = ecoinModel;
    JoinClassActionSheetView *view = [JoinClassActionSheetView shareInstance];
    view.frame = self.view.frame;
    view.model = self.courseModel;
    view.ecoinModel = self.ecoinModel;
    view.joinClassBlock = ^{
        if ([self.courseModel.isFree isEqualToString:@"1"]) {
            NSMutableDictionary *params = @{}.mutableCopy;
            params[@"courseId"] = self.courseModel.courseId;
            [ApiUtil postWithParent:self url:[ApiUtilHeader addLiveCourseOrder] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                JoinClassResultViewVontroller *vc = [[JoinClassResultViewVontroller alloc] init];
                [vc showWithController:self title:@"课程已加入到我的学习" ecoinBalance:@"" sureButtonTitle:@"立即学习" completionBlock:^{
                    [self loadData];
                }];
            } fail:nil];
        }else{
            if ([ecoinModel.nowVirtualMoney integerValue] >= [self.courseModel.coursePrice integerValue]) {
                FKAlertController *alert = [[FKAlertController alloc] init];
                [alert showAlertWithController:self title:[NSString stringWithFormat:@"确认花费%@艺币购买%@的直播课程《%@》吗？",self.courseModel.coursePrice, self.courseModel.teacherName ,self.courseModel.courseTitle] content:[NSString stringWithFormat:@"当前账户：%@艺币\n\n您即将购买的商品为虚拟服务产品，不支持退货，请谨慎下单",self.ecoinModel.nowVirtualMoney] sureClickBlock:^{
                    NSMutableDictionary *params = @{}.mutableCopy;
                    params[@"courseId"] = self.courseModel.courseId;
                    [ApiUtil postWithParent:self url:[ApiUtilHeader addLiveCourseOrder] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                        if (response) {
                            [ApiUtil getWithParent:self url:[ApiUtilHeader selectUserWalletByUserId] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
                                if (response) {
                                    ECoinModel *model = [ECoinModel yy_modelWithDictionary:response[@"data"]];
                                    JoinClassResultViewVontroller *vc = [[JoinClassResultViewVontroller alloc] init];
                                    [vc showWithController:self title:@"课程购买成功" ecoinBalance:[NSString stringWithFormat:@"当前账户：%@艺币",model.nowVirtualMoney] sureButtonTitle:@"立即学习" completionBlock:^{
                                        [self loadData];
                                    }];
                                }
                            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {

                            }];
                        }
                        
                    } fail:nil];
                } sureCompletion:^{
                    
                }];
            }else{//艺币余额不足
                FKAlertController *alert = [[FKAlertController alloc] init];
                [alert showAlertWithController:self title:@"艺币不足提醒" content:[NSString stringWithFormat:@"课程售价：%@艺币\n当前账户：%@艺币\n需要充值：%ld艺币",self.courseModel.coursePrice,self.ecoinModel.nowVirtualMoney,[self.courseModel.coursePrice integerValue] - [ecoinModel.nowVirtualMoney integerValue]] cancelButtonTitle:@"取消" sureButtonTitle:@"去充值" sureClickBlock:^{
                    ECoinRechargeViewController *vc= [[ECoinRechargeViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } sureCompletion:^{
                    
                }];
            }
        }
        
        
        
        
        
    };
    [view show];
}



//保存课时排序
- (IBAction)saveChapterSort:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"保存排序"]) {
        self.isSort = YES;
        NSMutableDictionary *params = @{}.mutableCopy;
        NSMutableArray *sortArray = [NSMutableArray array];
        [self.courseChapters enumerateObjectsUsingBlock:^(AMCourseChapterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *sort = [NSMutableDictionary dictionary];
            sort[@"chapterSort"] = @(idx + 1);
            sort[@"chapterId"] = obj.chapterId;
            [sortArray addObject:sort.copy];
        }];
        params[@"chapterList"] = sortArray.copy;
        params[@"courseId"] = self.courseModel.courseId;
        NSLog(@"%@",params);
        [ApiUtil postWithParent:self url:[ApiUtilHeader updateLiveCourseChapterSort] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            self.sortBackView.hidden = YES;
            [self.tableView setEditing:NO animated:YES];
            [SVProgressHUD showSuccess:[response objectForKey:@""] completion:^{
                
                self.teacherBottomView.hidden = NO;
                [self loadData];
            }];
        } fail:nil];
    }else if ([sender.titleLabel.text isEqualToString:@"取消"]){
        self.courseChapters = [NSMutableArray arrayWithArray:self.courseModel.courseChapters];
        self.isSort = NO;
        self.sortBackView.hidden = YES;
        [self.tableView setEditing:NO animated:YES];
        self.teacherBottomView.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
            [self.tableView reloadData];
        });
        
        
        
    }
}
//开启排序
- (IBAction)startChapterSort:(UIButton *)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    self.sortBackView.hidden = NO;
    self.teacherBottomView.hidden = YES;
}
//完结课程
- (IBAction)finishChapter:(UIButton *)sender {
    FKAlertController *alert = [[FKAlertController alloc] init];
    [alert showAlertWithController:self title:@"确定结束课程吗？" content:@"课程结束后无法再添加新的课时" sureClickBlock:^{
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"courseId"] = self.courseModel.courseId;
        [ApiUtil postWithParent:self url:[ApiUtilHeader stopLiveCourse] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            [SVProgressHUD showSuccess:@"课程已成功完结" completion:^{
                [self loadData];
            }];
            
        } fail:nil];
    } sureCompletion:^{
        
    }];
    
}
//添加新课时
- (IBAction)addNewChapterClick:(UIButton *)sender {
    AMCourseChapterCreateViewController *chapterVC = [[AMCourseChapterCreateViewController alloc] init];
    AMCourseChapterModel *model = [AMCourseChapterModel new];
    model.chapterSort = StringWithFormat(@(self.courseModel.courseChapters.count+1));
    model.isFree = self.courseModel.isFree;
    chapterVC.model = model;
    chapterVC.courseModel = self.courseModel;
    chapterVC.isEditChapter = NO;
    chapterVC.courseIsFree = self.courseModel.isFree;
    @weakify(self);
    chapterVC.clickToAddBlock = ^(AMCourseChapterModel * _Nonnull model) {
        @strongify(self);
        [self addNewChapter:model];
    };

    [self.navigationController presentViewController:chapterVC animated:YES completion:nil];
}


#pragma mark - 网络请求
- (void)addNewChapter:(AMCourseChapterModel *)model {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"courseId"] = self.courseModel.courseId;
    params[@"chapterSort"] = model.chapterSort;
    params[@"chapterTitle"] = model.chapterTitle;
    params[@"isFree"] = model.isFree;
    params[@"liveStartTime"] = [NSString stringWithFormat:@"%@:00",model.liveStartTime];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader addLiveCourseChapter] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        
        [self loadData];
    } fail:nil];
}

- (void)publish{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"courseId"] = self.courseModel.courseId;
    [ApiUtil postWithParent:self url:[ApiUtilHeader publishLiveCourse] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        AMCoursePublishViewController *publish = [[AMCoursePublishViewController alloc] init];
        publish.success = YES;
        publish.model = self.courseModel;
        [self.navigationController pushViewController:publish animated:YES];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        AMCoursePublishViewController *publish = [[AMCoursePublishViewController alloc] init];
        publish.success = NO;
        [self.navigationController pushViewController:publish animated:YES];
    }];
}

- (void)loadData{
    if (self.tableView.isEditing) {
        [self.tableView endAllFreshing];
        return;
    }
    [ApiUtil getWithParent:self url:[ApiUtilHeader getLiveCourseDetail:self.courseId] params:nil success:^(NSInteger code, id  _Nullable response) {
//        NSLog(@"%@",response);
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.courseModel = [AMCourseModel yy_modelWithDictionary:data];
            self.courseChapters = [NSMutableArray arrayWithArray:self.courseModel.courseChapters];
            if ([self.courseModel.isMySelf isEqualToString:@"2"]) {
                [self getOtherUserInfo];
            }
            [self.tableView reloadData];
        }
        [self.tableView endAllFreshing];
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
    }];
}
/// 关注艺术家
- (void)focusArtist{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"uid"] = [UserInfoManager shareManager].uid;
    params[@"collect_uid"] = self.courseModel.teacherId;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader collectUser] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self getOtherUserInfo];
    } fail:nil];
}

/// 获取是否关注了艺术家的状态
- (void)getOtherUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"uid"] = [UserInfoManager shareManager].uid;
    param[@"artuid"] = self.courseModel.teacherId;
    [ApiUtil postWithParent:self url:[ApiUtilHeader getOtherUserInfo] needHUD:NO params:param.copy success:^(NSInteger code, id  _Nullable response) {
        
        NSDictionary *data = (NSDictionary *)[response objectForKey:@"data"];
        if (data && data.count) {
            self.userModel = [CustomPersonalModel yy_modelWithDictionary:data];
            [self.tableView reloadData];
        }
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
    }];
}





#pragma mark - SET
- (void)setCourseModel:(AMCourseModel *)courseModel{
    _courseModel = courseModel;
    //判断当前课程是否是自己的
    if ([courseModel.isMySelf isEqualToString:@"1"]) {
        if ([courseModel.liveCourseStatus isEqualToString:@"2"]) {
            self.joinStudyView.hidden = YES;
            self.teacherBottomView.hidden = YES;
        }else{
            self.joinStudyView.hidden = YES;
            self.teacherBottomView.hidden = NO;
        }
        
        
    }else{//不是自己的
        self.teacherBottomView.hidden = YES;
        //判断当前用户有没有买课程
        if ([courseModel.isBuy isEqualToString:@"1"]) {
            self.joinStudyView.hidden = YES;
        }else{
            self.joinStudyView.hidden = NO;
        }
    }
    
    //课程完结不能再添加新的课时
    if ([courseModel.liveCourseStatus isEqualToString:@"7"]) {
        self.addChapterButton.hidden = YES;
    }else{
        self.addChapterButton.hidden = NO;
    }
    
    //判断课程是否可以完结
    if (courseModel.totalLessonNum.integerValue > 0 && [courseModel.totalLessonNum isEqualToString:courseModel.totalLiveLessonNum] && ![courseModel.liveCourseStatus isEqualToString:@"7"]) {
        self.finishChapterButton.enabled = YES;
    }else{
        self.finishChapterButton.enabled = NO;
    }
    
    
    
    //判断审核状态view是否显示
    if ([courseModel.isMySelf isEqualToString:@"1"] && [courseModel.liveCourseStatus isEqualToString:@"3"]) {
        self.reviewStatusView.hidden = NO;
        self.reviewFailReasonLabel.text = courseModel.verifyRemark;
    }else{
        self.reviewStatusView.hidden = YES;
    }
    
    
    if (([courseModel.liveCourseStatus isEqualToString:@"1"] || [courseModel.liveCourseStatus isEqualToString:@"3"]) && courseModel.courseChapters.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBtn]];
    }else{
        if (![courseModel.liveCourseStatus isEqualToString:@"1"] && ![courseModel.liveCourseStatus isEqualToString:@"3"]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self shareButton]];
        }
    }
    
    //判断排序是否可用
    if ([courseModel.isMySelf isEqualToString:@"1"]) {
        if (courseModel.courseChapters.count > 1 && ([courseModel.liveCourseStatus isEqualToString:@"1"] || [courseModel.liveCourseStatus isEqualToString:@"3"])) {
            self.sortButton.enabled = YES;
        }else{
            self.sortButton.enabled = NO;
        }
    }
    
    
    //标题显示
    if ([courseModel.liveCourseStatus isEqualToString:@"1"] || [courseModel.liveCourseStatus isEqualToString:@"3"]) {
        self.navigationItem.title = @"创建直播课";
    }else{
        self.navigationItem.title = @"课程详情";
    }
    
    
}

- (void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(15, 0, 15, 0);
    self.tableView.separatorColor = RGB(242, 242, 242);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassDetailHeadImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ClassDetailHeadImageCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassDetailTextCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ClassDetailTextCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassDetailArtistCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ClassDetailArtistCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassDetailClassCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ClassDetailClassCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassDetailTeacherClassCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ClassDetailTeacherClassCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData)];
    self.tableView.tableFooterView = [UIView new];
    
}
#pragma mark - ClassDetailTeacherClassCellDelegate
- (void)cellButtonClick:(ClassDetailTeacherClassCell *)cell buttonTitle:(NSString *)title chapterModel:(AMCourseChapterModel *)model indexPath:(nonnull NSIndexPath *)indexPath{
    if (self.tableView.editing){
        return;
    }
    if ([title isEqualToString:@"进入房间"]) {
        if ([model.liveStatus isEqualToString:@"2"] || [model.liveStatus isEqualToString:@"3"]) {
            AMLivePushViewController *vc = [[AMLivePushViewController alloc] init];
            vc.chapterModel = model;
            vc.courseModel = self.courseModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.courseModel.courseChapters enumerateObjectsUsingBlock:^(AMCourseChapterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.liveStatus isEqualToString:@"1"] || [obj.liveStatus isEqualToString:@"2"] || [obj.liveStatus isEqualToString:@"3"]) {
                    if ([obj.chapterId isEqualToString:model.chapterId]) {
                        AMLivePushViewController *vc = [[AMLivePushViewController alloc] init];
                        vc.chapterModel = model;
                        vc.courseModel = self.courseModel;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        [SVProgressHUD showError:[NSString stringWithFormat:@"您当前正在直播课时%@，无法进入本课时的直播间",obj.chapterSort]];
                    }
                }
                
            }];
        }
    }else if([title isEqualToString:@"删除"]){
        FKAlertController *alert = [[FKAlertController alloc] init];
        [alert showAlertWithController:self title:@"确定删除这个课时吗？" content:@"删除的课时将无法恢复，请慎重操作！" sureClickBlock:^{
            NSMutableDictionary *params = @{}.mutableCopy;
            params[@"courseId"] = model.courseId;
            params[@"chapterId"] = model.chapterId;
            
            [ApiUtil postWithParent:self url:[ApiUtilHeader deleteLiveCourseChapter] params:params.copy success:^(NSInteger code, id  _Nullable response) {
                [self.courseChapters removeObject:model];
                [self.tableView reloadData];
                [self loadData];
                
            } fail:nil];
        } sureCompletion:^{
            
        }];
        

    }else if([title isEqualToString:@"编辑"]){
        NSLog(@"%@",title);
        
        AMCourseChapterCreateViewController *chapterVC = [[AMCourseChapterCreateViewController alloc] init];
        chapterVC.model = model;
        chapterVC.courseModel = self.courseModel;
        chapterVC.isEditChapter = YES;
        chapterVC.courseIsFree = self.courseModel.isFree;
        @weakify(self);
        chapterVC.clickToEditBlock = ^(AMCourseChapterModel * _Nonnull model1) {
            @strongify(self);
            [self saveChapter:model1 indexPath:indexPath];
        };
        [self.navigationController presentViewController:chapterVC animated:YES completion:nil];
        
    }else if([title isEqualToString:@"结束课时"]){
        FKAlertController *alert = [[FKAlertController alloc] init];
        [alert showAlertWithController:self title:@"提示" content:[NSString stringWithFormat:@"确认结束课时%@：%@的直播吗？",model.chapterSort , model.chapterTitle] sureClickBlock:^{
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"courseId"] = model.courseId;
            dic[@"chapterId"] = model.chapterId;
            [ApiUtil postWithParent:self url:[ApiUtilHeader stopLiveCourseChapter] needHUD:YES params:dic success:^(NSInteger code, id  _Nullable response) {
                [self loadData];
            } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
                
            }];
        } sureCompletion:^{
            
        }];
    }else if([title isEqualToString:@"观看回放"]){
//        VideoReplayListViewController *vc = [[VideoReplayListViewController alloc] init];
//        vc.chapterModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
        
        AMCourseVideoReplayController *vc = [[AMCourseVideoReplayController alloc] init];
        vc.chapterModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"观看直播"]){
        AMLivePlayViewController *vc = [[AMLivePlayViewController alloc] init];
        vc.chapterModel = model;
        vc.courseModel = self.courseModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)saveChapter:(AMCourseChapterModel *)model indexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"courseId"] = model.courseId;
    params[@"chapterId"] = model.chapterId;
    params[@"chapterTitle"] = model.chapterTitle;
    params[@"liveStartTime"] = [NSString stringWithFormat:@"%@:00",model.liveStartTime];
    params[@"isFree"] = model.isFree;
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader updateLiveCourseChapter] params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.courseChapters replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadData];
//        [self loadData];
    } fail:nil];
}

#pragma mark - UITableViewDelegate , UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        AMCourseChapterModel *chapterModel = self.courseModel.courseChapters[indexPath.row];
        if ([self.courseModel.isMySelf isEqualToString:@"2"]) {
            if ([self.courseModel.isBuy isEqualToString:@"1"]) {// 已购买/已加入课程
                //直播状态 1:未直播;2:直播中;3:直播中讲师离开直播间；4:直播已结束=回放视频生成中;5:回放视频生成失败;6:回放视频生成成功
                if ([chapterModel.liveStatus isEqualToString:@"2"] || [chapterModel.liveStatus isEqualToString:@"3"]) {
                    AMLivePlayViewController *vc = [[AMLivePlayViewController alloc] init];
                    vc.chapterModel = self.courseModel.courseChapters[indexPath.row];
                    vc.courseModel = self.courseModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([chapterModel.liveStatus isEqualToString:@"4"] || [chapterModel.liveStatus isEqualToString:@"5"]){
                    
                }else if ([chapterModel.liveStatus isEqualToString:@"6"]){
//                    VideoReplayListViewController *vc = [[VideoReplayListViewController alloc] init];
//                    vc.chapterModel = chapterModel;
//                    [self.navigationController pushViewController:vc animated:YES];
                    
                    AMCourseVideoReplayController *vc = [[AMCourseVideoReplayController alloc] init];
                    vc.chapterModel = chapterModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                if ( [self.courseModel.isBuy isEqualToString:@"2"] && [chapterModel.isFree isEqualToString:@"1"]) {// 未购买/未加入课程
                    //直播状态 1:未直播;2:直播中;3:直播中讲师离开直播间；4:直播已结束=回放视频生成中;5:回放视频生成失败;6:回放视频生成成功
                    if ([chapterModel.liveStatus isEqualToString:@"2"] || [chapterModel.liveStatus isEqualToString:@"3"]) {
                        AMLivePlayViewController *vc = [[AMLivePlayViewController alloc] init];
                        vc.chapterModel = self.courseModel.courseChapters[indexPath.row];
                        vc.courseModel = self.courseModel;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else if ([chapterModel.liveStatus isEqualToString:@"4"] || [chapterModel.liveStatus isEqualToString:@"5"]){
//
                    }else if ([chapterModel.liveStatus isEqualToString:@"6"]){
//                        VideoReplayListViewController *vc = [[VideoReplayListViewController alloc] init];
//                        vc.chapterModel = chapterModel;
//                        [self.navigationController pushViewController:vc animated:YES];
                        
                        AMCourseVideoReplayController *vc = [[AMCourseVideoReplayController alloc] init];
                        vc.chapterModel = chapterModel;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                }else{
                    [SVProgressHUD showMsg:@"请先加入课程！"];
                }
            }
                
        }
    }

    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.courseModel.isMySelf isEqualToString:@"1"]){
        if (section == 2) {
            ClassDetailClassHeadView *head = [ClassDetailClassHeadView share];
            head.model = self.courseModel;
            return head;
        }else{
            return nil;
        }
    }else{
        if (section == 3) {
            ClassDetailClassHeadView *head = [ClassDetailClassHeadView share];
            head.model = self.courseModel;
            return head;
        }else{
            return nil;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.courseModel.isMySelf isEqualToString:@"1"]){
        if (section == 2) {
            return 40;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        if (section == 3) {
            return 40;
        }else{
            return CGFLOAT_MIN;
        }
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.courseModel.isMySelf isEqualToString:@"1"]) {
        return 3;
    }else{
        return 4;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.courseModel.isMySelf isEqualToString:@"1"]) {//判断是否是自己的课程
        if (indexPath.section == 0) {
            ClassDetailHeadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassDetailHeadImageCell class]) forIndexPath:indexPath];
            cell.courseModel = self.courseModel;
            return cell;
        }else if(indexPath.section == 1){
            ClassDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassDetailTextCell class]) forIndexPath:indexPath];
            cell.model = self.courseModel;
            cell.editClickBlock = ^{
                AMCourseNewViewController *vc = [[AMCourseNewViewController alloc] init];
                vc.isCourseEdit = YES;
                vc.model = self.courseModel;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }else{
            ClassDetailTeacherClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassDetailTeacherClassCell class]) forIndexPath:indexPath];
            cell.courseModel = self.courseModel;
            cell.chapterModel = self.isSort ? self.courseChapters[indexPath.row] : self.courseModel.courseChapters[indexPath.row];
//            cell.chapterModel = self.courseChapters[indexPath.row];
            cell.delegate = self;
            cell.indexPath = indexPath;
            return cell;
        }
    }else{
        if (indexPath.section == 0) {
            ClassDetailHeadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassDetailHeadImageCell class]) forIndexPath:indexPath];
            cell.courseModel = self.courseModel;
            return cell;
        }else if(indexPath.section == 1){
            ClassDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassDetailTextCell class]) forIndexPath:indexPath];
            cell.model = self.courseModel;
            return cell;
        }else if(indexPath.section == 2){
            ClassDetailArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassDetailArtistCell class]) forIndexPath:indexPath];
            cell.focusClickBlock = ^(NSString * _Nonnull artistID) {
                //关注
                [self focusArtist];
            };
            cell.gotoArtistHomeBlock = ^{
                AMBaseUserHomepageViewController *vc = [[AMBaseUserHomepageViewController alloc] init];
                vc.artuid = self.courseModel.teacherId;
                [self.navigationController pushViewController:vc animated:YES];
            };
            cell.model = self.courseModel;
            cell.userModel = self.userModel;
            return cell;
        }else {// 3
            ClassDetailClassCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassDetailClassCell class]) forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.courseModel = self.courseModel;
            cell.model = self.courseChapters[indexPath.row];
            return cell;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.courseModel.isMySelf isEqualToString:@"1"]){
        if (section == 0) {
            return 1;
        }else if(section == 1){
            return 1;
        }else{ // 2
            return self.courseChapters.count;
        }
    }else{
        if (section == 0) {
            return 1;
        }else if(section == 1){
            return 1;
        }else if(section == 2){
            return 1;
        }else{ // 3
            return self.courseChapters.count;
        }
    }
    
}
#pragma mark - UITbaleView  cell 排序相关


//哪些cell可以开启编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.courseModel.isMySelf isEqualToString:@"1"]){
        if (indexPath.section == 2) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    
}

//决定哪些cell可以开启排序
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.courseModel.isMySelf isEqualToString:@"1"]){
        if (indexPath.section == 2) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

//cell编辑样式 UITableViewCellEditingStyle
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

//排序后交换数据源
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{

    AMCourseChapterModel *model = self.courseModel.courseChapters[sourceIndexPath.row];
    [self.courseChapters removeObjectAtIndex:sourceIndexPath.row];
    [self.courseChapters insertObject:model atIndex:destinationIndexPath.row];
}


//控制cell的拖拽排序只在cell所在的section
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    return proposedDestinationIndexPath;
}

//cell开启编辑模式后是否向中间缩进
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}


#pragma mark - AMShareViewDelegate
- (void)shareView:(AMShareView *)shareView didSelectedWithItemStyle:(AMShareViewItemStyle)itemStyle{
    if (![UserInfoManager shareManager].isLogin) {
        [self jumpToLoginWithBlock:nil];
        return;
    }
}
@end
