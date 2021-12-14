//
//  DiscussInfoFooterView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussInfoFooterView.h"

#import "DiscussReplyTableCell.h"
#import "DiscussReplyTableFooterView.h"

#import "DiscussItemInfoModel.h"

@interface DiscussInfoFooterView () <UITableViewDelegate ,UITableViewDataSource, DiscussReplyTableFooterDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *replyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (nonatomic ,strong) DiscussReplyTableFooterView *footerView;

@end

@implementation DiscussInfoFooterView {
    NSMutableArray <DiscussItemInfoModel *>*_dataArray;
}

- (DiscussReplyTableFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DiscussReplyTableFooterView class]) owner:nil options:nil].lastObject;
        _footerView.frame = CGRectMake(0, 0, self.width, 40.0f);
        _footerView.delegate = self;
    }return _footerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _dataArray = @[].mutableCopy;
        
    _replyTableView.bgColorStyle = AMBaseBackgroundColorStyleGray;
    _replyTableView.delegate = self;
    _replyTableView.dataSource = self;
    
    _replyTableView.estimatedRowHeight = 44.0f;
    
    _replyTableView.rowHeight = UITableViewAutomaticDimension;
    [_replyTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DiscussReplyTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DiscussReplyTableCell class])];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 60.0f;
    frame.size.width -= 75.0f;
    [super setFrame:frame];
}

- (void)setModel:(DiscussItemInfoModel *)model {
    _model = model;
    
    _dataArray = _model.reply_data.mutableCopy;
    
    [_replyTableView reloadData];
    [_replyTableView layoutIfNeeded];
    _tableViewHeightConstraint.constant = _dataArray.count?_replyTableView.contentSize.height:CGFLOAT_MIN;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussReplyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DiscussReplyTableCell class]) forIndexPath:indexPath];
    
    cell.replyModel = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_model.un_see_num.integerValue)
        return self.footerView.height;
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_model.un_see_num.integerValue) {
        self.footerView.moreCount = _model.un_see_num.integerValue + 2;
        return self.footerView;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoFooter:didSelectedMore:withModel:)]) {
        [self.delegate infoFooter:self didSelectedMore:tableView withModel:self.model];
    }
}

#pragma mark - DiscussReplyTableFooterDelegate
- (void)footerView:(DiscussReplyTableFooterView *)footer didSelectedMore:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoFooter:didSelectedMore:withModel:)]) {
        [self.delegate infoFooter:self didSelectedMore:sender withModel:self.model];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
