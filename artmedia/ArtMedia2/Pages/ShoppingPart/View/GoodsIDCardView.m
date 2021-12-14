//
//  GoodsIDCardView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsIDCardView.h"

@interface GoodsIDCardView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *idcardIV;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *wxBtn;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *wxfBtn;
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *saveLocalBtn;

@property (nonatomic, copy) NSString *idcardUrl;
@property (nonatomic, weak) id <GoodsIDCardViewDelegate> delegate;

@end

@implementation GoodsIDCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (GoodsIDCardView *)shareInstance:(NSString *_Nullable)idcardUrl delegate:(id <GoodsIDCardViewDelegate>)delegate {
    GoodsIDCardView *idcardView = [GoodsIDCardView shareInstance];
    idcardView.idcardUrl = idcardUrl;
    idcardView.delegate = delegate;
    return idcardView;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.backgroundColor = [Color_Black colorWithAlphaComponent:0.9];
        self.frame = [UIScreen mainScreen].bounds;
    }return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _wxBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _wxfBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _saveLocalBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)setIdcardUrl:(NSString *)idcardUrl {
    _idcardUrl = idcardUrl;
    @weakify(self);
    [self.idcardIV am_setImageWithURL:_idcardUrl placeholderImage:nil contentMode:UIViewContentModeScaleToFill completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.wxBtn.enabled = YES;
            self.wxfBtn.enabled = YES;
            self.saveLocalBtn.enabled = YES;
        });
    }];
}

- (IBAction)clickToShareWX:(id)sender {
    @weakify(self);
    [self hide:^{
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardView:clickToShare:withImage:)]) {
            [self.delegate cardView:self clickToShare:0 withImage:self.idcardIV.image];
        }
    }];
}
- (IBAction)clickToShareWXF:(id)sender {
    @weakify(self);
    [self hide:^{
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardView:clickToShare:withImage:)]) {
            [self.delegate cardView:self clickToShare:1 withImage:self.idcardIV.image];
        }
    }];
}
- (IBAction)clickToSaveLocal:(id)sender {
    @weakify(self);
    [self hide:^{
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardView:clickToSaveLocal:)]) {
            [self.delegate cardView:self clickToSaveLocal:self.idcardIV.image];
        }
    }];
}
- (IBAction)clickToClose:(id)sender {
    [self hide];
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.stackView]) return NO;
    return YES;
}


@end
