//
//  AMAuctionPayResultTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionPayResultTableCell.h"

@implementation AMCopyLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0;
        self.pasteBoard = [UIPasteboard generalPasteboard];
        [self attachLongTapHandle];
    }return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self == [super initWithCoder:coder]) {
        self.numberOfLines = 0;
        self.pasteBoard = [UIPasteboard generalPasteboard];
        [self attachLongTapHandle];
    }return self;
}

- (void)attachLongTapHandle {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

- (void)longPressAction:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        // UILabel成为第一响应者
        [self becomeFirstResponder];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
        UIMenuItem *pasteMenueItem = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(pasteAction:)];
        UIMenuItem *cutMenuItem = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(cutAction:)];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, pasteMenueItem,cutMenuItem, nil]];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)) {
        return YES;
    }
    if (action == @selector(pasteAction:)) {
        return YES;
    }
    if (action == @selector(cutAction:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

- (void)copyAction:(id)sender {
    self.pasteBoard.string = self.text;
    NSLog(@"粘贴的内容为%@", self.pasteBoard.string);
}

- (void)pasteAction:(id)sender {
    self.text = self.pasteBoard.string;
}

- (void)cutAction:(id)sender  {
    self.pasteBoard.string = self.text;
    self.text = nil;
}

@end

@interface AMAuctionPayResultTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *itemStackView;
@property (weak, nonatomic) IBOutlet UIStackView *resultStackView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@end

@implementation AMAuctionPayResultTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    self.tipsLabel.font = [UIFont addHanSanSC:12.0 fontType:0];
    [self.itemStackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UILabel *)obj setFont:[UIFont addHanSanSC:14.0 fontType:0]];
    }];
    [self.resultStackView.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(AMCopyLabel *)obj setFont:[UIFont addHanSanSC:14.0 fontType:0]];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
