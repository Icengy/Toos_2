/*
 * Module:   TRTCVideoViewLayout
 * 
 * Function: 用于计算每个视频画面的位置排布和大小尺寸
 *
 */

#import "TRTCVideoViewLayout.h"
#import "AMTRTCVideoView.h"

#import "TRTCVideoLayoutCell.h"

#import <Masonry.h>

const static float VSPACE = 10.f;
const static float HSPACE = 20.f;
const static float MARGIN = 15.f;
#define BlockWidth  ((K_Width-MARGIN*4)/3)
#define BlokcHeight  (BlockWidth *16/9)

#define GridBlockWidth  (K_Width/2-1.0f)
#define GridBlokcHeight  (GridBlockWidth *16/9)

@interface TRTCVideoViewLayout () <UICollectionViewDataSource ,UICollectionViewDelegate>

@property (nonatomic ,strong) UILabel *countLabel;

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UICollectionViewFlowLayout *tilingLayout;
@property (nonatomic ,strong) UICollectionViewFlowLayout *gridLayout;
@end

@implementation TRTCVideoViewLayout


- (UIView *)list {
    return self.collectionView;
}

- (UIView *)label {
    return self.countLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        
        _countLabel.textColor = Color_Whiter;
        _countLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = [Color_Black colorWithAlphaComponent:0.4];
        _countLabel.layer.cornerRadius = 4.0f;
        _countLabel.clipsToBounds = YES;
        
        _countLabel.hidden = YES;
    }return _countLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.tilingLayout];
        _collectionView.backgroundColor = UIColor.clearColor;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[TRTCVideoLayoutCell class] forCellWithReuseIdentifier:NSStringFromClass([TRTCVideoLayoutCell class])];
        
    }return _collectionView;
}

- (UICollectionViewFlowLayout *)tilingLayout {
    if (!_tilingLayout) {
        _tilingLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _tilingLayout.itemSize = CGSizeMake(BlockWidth, BlokcHeight);
        _tilingLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        _tilingLayout.minimumLineSpacing = MARGIN;
        _tilingLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _tilingLayout.sectionInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
        
    }return _tilingLayout;
}

- (UICollectionViewFlowLayout *)gridLayout {
    if (!_gridLayout) {
        _gridLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _gridLayout.itemSize = CGSizeMake(GridBlockWidth, GridBlokcHeight);
        _gridLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _gridLayout.minimumLineSpacing = 0.1f;
        _gridLayout.minimumInteritemSpacing = 0.1f;
        _gridLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }return _gridLayout;
}

- (void)setView:(UIView *)view
{
    _view = view;
    [_view addSubview:self.collectionView];
    [_view addSubview:self.countLabel];
}

- (void)setType:(TCLayoutType)type
{
    _type = type;
    [self relayout:self.subViews];
}

- (void)relayout:(NSArray<UIView *> *)players {
    
    if (players == nil) return;
    AMTRTCVideoView *myView, *masterView;
    NSMutableArray <UIView *> *views_2 = @[].mutableCopy;
    for (int i = 0; i < players.count; i ++) {
        AMTRTCVideoView* playerView = (AMTRTCVideoView *)players[i];
        playerView.userInteractionEnabled = YES;
        
        playerView.layoutType = self.type;
        if (self.type == TC_Float && i == 0) {
            playerView.userInteractionEnabled = NO;
            [self.view insertSubview:playerView atIndex:0];
            [playerView hiddenTag:YES];
        }else {
            [playerView hiddenTag:NO];
        }
        
        if (!i) {
            [views_2 addObject:playerView];
        }else {
            if (playerView.isSelf) {
                myView = playerView;
                continue;
            }
            if (playerView.isMaster) {
                masterView = playerView;
                continue;
            }
        }
    }
    NSMutableArray <UIView *> *views = players.mutableCopy;
    [views removeObject:views_2.firstObject];
    
    if (myView) {
        [views_2 addObject:myView];
        [views removeObject:myView];
    }
    if (masterView) {
        [views_2 addObject:masterView];
        [views removeObject:masterView];
    }
    [views_2 addObjectsFromArray:views];
    
    self.subViews = views_2.copy;
    
    if (self.subViews.count == 0) return;
    if (self.subViews.count == 1) {
        self.subViews[0].frame = (CGRect){.origin = CGPointZero, .size = self.view.frame.size};
        self.countLabel.hidden = YES;
        return;
    }

    if (self.type == TC_Float) {
        [UIView beginAnimations:@"TRTCLayoutEngine" context:nil];
        [UIView setAnimationDuration:0.25];
        self.subViews[0].frame = (CGRect){.origin = CGPointZero, .size = self.view.frame.size};
        [UIView commitAnimations];
        
        self.collectionView.collectionViewLayout = self.tilingLayout;
        self.collectionView.alwaysBounceHorizontal = YES;
        self.collectionView.alwaysBounceVertical = NO;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-(SafeAreaBottomHeight + 10));
            make.height.offset(BlokcHeight);
        }];
        if (self.subViews.count) {
            self.countLabel.hidden = NO;
            self.countLabel.text = [NSString stringWithFormat:@"当前人数：%@人",@(self.subViews.count)];
            CGSize realSize = [self.countLabel.text sizeWithFont:self.countLabel.font andMaxSize:self.view.size];
            [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.collectionView.mas_top).offset(-10.0f);
                make.left.equalTo(self.collectionView.mas_left).offset(MARGIN);
                make.size.sizeOffset(CGSizeMake(realSize.width+8.0f, realSize.height+4.0f));
            }];
        }else {
            self.countLabel.hidden = YES;
        }
    }else if (self.type == TC_Gird) {
        self.countLabel.hidden = YES;
        self.collectionView.collectionViewLayout = self.gridLayout;
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.alwaysBounceHorizontal = NO;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
        }];
    }
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    [self reload];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray <NSString *>* videoViewArray = @[].mutableCopy;
        for (TRTCVideoLayoutCell *cell in self.collectionView.visibleCells) {
            [videoViewArray addObject:cell.mainView.userId];
        }
        if ([self.delegate respondsToSelector:@selector(trtcVideoForVisibleSupplementary:)]) {
            [self.delegate trtcVideoForVisibleSupplementary:videoViewArray];
        }
    });
}

- (void)reload {
    if (self.collectionView) [self.collectionView reloadData];
}

- (void)hideWith:(BOOL)hidden {
    CGFloat offsetY = BlokcHeight + 10.0f;
    if (hidden) {
        self.countLabel.y += offsetY;
        self.collectionView.y += offsetY;
    }else {
        self.countLabel.y -= offsetY;
        self.collectionView.y -= offsetY;
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == TC_Gird)
        return self.subViews.count;
    return self.subViews.count - 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRTCVideoLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TRTCVideoLayoutCell class]) forIndexPath:indexPath];
    
    if (self.type == TC_Gird) {
        cell.mainView = (AMTRTCVideoView *)self.subViews[indexPath.item];
    }else {
        cell.mainView = (AMTRTCVideoView *)self.subViews[indexPath.item + 1];
    }
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSMutableArray <NSString *>* videoViewArray = @[].mutableCopy;
    for (TRTCVideoLayoutCell *cell in self.collectionView.visibleCells) {
        [videoViewArray addObject:cell.mainView.userId];
    }
    if ([self.delegate respondsToSelector:@selector(trtcVideoForVisibleSupplementary:)]) {
        [self.delegate trtcVideoForVisibleSupplementary:videoViewArray];
    }
}

// 将view等分为total块，处理好边距
#define FitH(rect) rect.size.height = (rect.size.width)/9.0*16
- (CGRect)gird:(int)total at:(int)at
{
    CGRect atRect = CGRectZero;
    CGFloat H = self.view.frame.size.height;
    CGFloat W = self.view.frame.size.width;
    // 等分主view，2、4、9...
    // 6宫格不能处理
    if (total <= 2) {
        atRect.size.width = (W - HSPACE - 2 * MARGIN) / 2;
        FitH(atRect);
        atRect.origin.y = (H-atRect.size.height)/2;
        if (at == 0) {
            atRect.origin.x = MARGIN;
        } else {
            atRect.origin.x = W-MARGIN-atRect.size.width;
        }
        return atRect;
    } else if (total <= 4) {
        atRect.size.width = (W - HSPACE - 2 * MARGIN) / 2;
        FitH(atRect);
        if (at / 2 == 0) {
            atRect.origin.y = (H - VSPACE)/2-atRect.size.height;
        } else {
            atRect.origin.y = (H + VSPACE)/2;
        }
        
        if (at % 2 == 0) {
            atRect.origin.x = MARGIN;
        } else {
            atRect.origin.x = W-MARGIN-atRect.size.width;
        }
        return atRect;
    } else if (total <= 6) {
        atRect.size.width = (W - 2 * HSPACE - 2 * MARGIN) / 3;
        FitH(atRect);
        if (at / 3 == 0) {
            atRect.origin.y = H/2 - atRect.size.height - VSPACE;
        } else {
            atRect.origin.y = H/2 + VSPACE;
        }
        
        if (at % 3 == 0) {
            atRect.origin.x = MARGIN;
        } else if (at % 3 == 1) {
            atRect.origin.x = W/2 - atRect.size.width/2;
        } else {
            atRect.origin.x = W - atRect.size.width - MARGIN;
        }
        return atRect;
    } else {
        if (at >= 9) {
            return CGRectZero;
        }
        
        atRect.size.width = (W - 2 * HSPACE - 2 * MARGIN) / 3;
        FitH(atRect);
        if (at / 3 == 0) {
            atRect.origin.y = H/2 - atRect.size.height/2 - VSPACE - atRect.size.height;
        } else if (at / 3 == 1) {
            atRect.origin.y = H/2 - atRect.size.height/2;
        } else {
            atRect.origin.y = H/2 + atRect.size.height/2 + VSPACE;
        }
        
        if (at % 3 == 0) {
            atRect.origin.x = MARGIN;
        } else if (at % 3 == 1) {
            atRect.origin.x = W/2 - atRect.size.width/2;
        } else {
            atRect.origin.x = W - atRect.size.width - MARGIN;
        }
        return atRect;
    }
    return atRect;
}

@end
