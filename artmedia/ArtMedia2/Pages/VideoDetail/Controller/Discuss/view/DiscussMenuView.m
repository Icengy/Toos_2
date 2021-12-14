//
//  DiscussMenuView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "DiscussMenuView.h"

@interface DiscussMenuView () <UITableViewDelegate ,UITableViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *conentView;

@end

@implementation DiscussMenuView {
    NSArray *_dataArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static BOOL _hadInstance = NO;
+ (instancetype)shareInstance {
    DiscussMenuView *inputView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    return inputView;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.backgroundColor = [Color_Black colorWithAlphaComponent:0.2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [Color_Black colorWithAlphaComponent:0.2];
    self.frame = CGRectMake(0, 0, K_Width, K_Height);
    
    _dataArray = @[@"复制评论", @"举报"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50.0f;
    
    _tableView.sectionHeaderHeight = CGFLOAT_MIN;
    _tableView.tableHeaderView = [UIView new];
    
    [_tableView reloadData];
}

- (void)setFrame:(CGRect)frame {
    [self.conentView addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(15.0f, 15.0f)];
    
    [super setFrame:frame];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell) [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    else cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:NSStringFromClass([self class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
    cell.textLabel.textColor = Color_Black;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    AMButton *button = [AMButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.width, 50.0f);
    
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:Color_Black forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
    
    [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hide:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(menuView:didSelectMenuWay:)]) {
            [self.delegate menuView:self didSelectMenuWay:indexPath.row];
        }
    }];
}

#pragma mark -
- (void)show {
    if (!self) return;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^ {
//        self.y -= 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [self hide:nil];
}

- (void)hide:(void (^ __nullable)(void))completion {
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^ {

    } completion:^(BOOL finished) {
        if (completion) completion();
        _hadInstance = NO;
        [self removeFromSuperview];
    }];
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_conentView]) {
        return NO;
    }
    return YES;
}

@end
