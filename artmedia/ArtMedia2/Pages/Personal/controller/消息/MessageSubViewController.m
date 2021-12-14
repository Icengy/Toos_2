//
//  MessageSubViewController.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MessageSubViewController.h"

#import "MessageNewListController.h"

#import "MyMessageNormalCell.h"

#import "MessageInfoModel.h"

#import "AMEmptyView.h"

@interface MessageSubViewController ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic , strong) NSMutableArray <MessageSubModel *>*listData;
@end

@implementation MessageSubViewController
- (NSMutableArray <MessageSubModel *>*)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
        NSInteger index = (self.type.integerValue == 1)?5:4;
        NSString *tip = AMUserDefaultsObjectForKey(@"is_include_auc");
        if (self.type.integerValue == 1) {
            if ([tip isEqualToString:@"1"]) {
                index = 5;
            }else{
                index = 4;
            }
        }else{
            index = 4;
        }
        
        for (int i =0 ; i < index; i ++) {
            MessageSubModel *model = [[MessageSubModel alloc] init];
            model.userType = self.type;
            if (i == 0) {
                model.mtype = @"1";
            }
            if (i == 1) {
                model.mtype = @"3";
            }
            if (i == 2) {
                model.mtype = @"2";
            }
            if (i == 3) {
                model.mtype = @"4";
            }
            if (i == 4) {
                model.mtype = @"5";
            }
            [_listData addObject:model];
        }
    }
    return _listData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData:nil];
}

- (void)setUp {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyMessageNormalCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyMessageNormalCell class])];
    
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
}

- (void)loadData:(id _Nullable)sender {
    self.tableView.allowsSelection = NO;
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[UserInfoManager shareManager].uid forKey:@"uid"];
    [dic setValue:self.type forKey:@"userType"];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader selectNewsList] needHUD:NO params:dic success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSArray <MessageSubModel *>*data = [NSArray yy_modelArrayWithClass:[MessageSubModel class] json:[response objectForKey:@"data"]];
        if (data && data.count) {
            for (int i = 0; i < self.listData.count; i ++) {
                MessageSubModel *model = [self.listData objectAtIndex:i];
                [data enumerateObjectsUsingBlock:^(MessageSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.userType isEqualToString:model.userType] &&
                        [obj.mtype isEqualToString:model.mtype]) {
                        
                        [self.listData replaceObjectAtIndex:idx withObject:obj];
                        *stop = YES;
                    }
                }];
            }
        }
        [self.tableView reloadData];
        
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyMessageNormalCell class]) forIndexPath:indexPath];
    
    if (self.listData.count) cell.model = [self.listData objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 10.0f;
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageNewListController * vc = [[MessageNewListController alloc]init];
    vc.model = [self.listData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
