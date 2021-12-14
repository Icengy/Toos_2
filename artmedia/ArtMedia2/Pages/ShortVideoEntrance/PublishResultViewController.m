//
//  PublishResultViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PublishResultViewController.h"

#import "PublishResultHeaderTableCell.h"
#import "PublishResultIDCardTableCell.h"
#import "PublishResultFooterTableCell.h"

#import "UIViewController+BackButtonHandler.h"

#import "VideoListModel.h"

@interface PublishResultViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation PublishResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bgColorStyle = AMBaseBackgroundColorStyleGray;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[UIView new]];
    [_tableView setTableHeaderView:[UIView new]];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PublishResultHeaderTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PublishResultHeaderTableCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PublishResultFooterTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PublishResultFooterTableCell class])];
    
    if ([UserInfoManager shareManager].isArtist) {
        [self.navigationItem setTitle:@"认证信息"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PublishResultIDCardTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PublishResultIDCardTableCell class])];
    }else {
        [self.navigationItem setTitle:@"发布成功"];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //禁用右滑返回手势
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hadGoods?3:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PublishResultHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PublishResultHeaderTableCell class]) forIndexPath:indexPath];
        cell.videoName = self.videoName;
        return cell;
    }
    if (indexPath.row == 1 && _hadGoods) {
        PublishResultIDCardTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PublishResultIDCardTableCell class]) forIndexPath:indexPath];
        cell.artworkIDCard = self.artworkIDCard;
        return cell;
    }
    PublishResultFooterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PublishResultFooterTableCell class]) forIndexPath:indexPath];
    [cell.getBtn addTarget:self action:@selector(clickToGet:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark -
- (BOOL)navigationShouldPopOnBackButton {
    [self clickToGet:nil];
    return NO;
}

- (void)clickToGet:(id)sender {
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSInteger index = [viewControllers indexOfObject:self];
    index -= 2;
    if (index < 0)  index = 0;
    UIViewController *nextViewController = [viewControllers objectAtIndex:index];
    [self.navigationController popToViewController:nextViewController animated:YES];
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
