//
//  GoodsPartBannerView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "GoodsPartBannerView.h"

#import <SDCycleScrollView/SDCycleScrollView.h>
#import <YBImageBrowser/YBImageBrowser.h>

@interface GoodsPartBannerView () <SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_top_constraint;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;

@property (weak, nonatomic) IBOutlet AMButton *editBtn;

@end

@implementation GoodsPartBannerView {
    NSMutableArray *_browserArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _browserArray = @[].mutableCopy;
    
    _sortLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _sortLabel.backgroundColor = [Color_Black colorWithAlphaComponent:0.3];
    
    _btn_top_constraint.constant = StatusBar_Height;
    
    _bannerView.delegate = self;
    _bannerView.pageControlDotSize = CGSizeMake(10, 10);
    _bannerView.pageDotColor = Color_Whiter;
    _bannerView.currentPageDotColor = Color_MainBg;
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _bannerView.hidesForSinglePage = YES;
    _bannerView.autoScrollTimeInterval = 3.0;
    _bannerView.placeholderImage = ImageNamed(@"PersonalDefaultHeader");
    
    //背景色
    _bannerView.backgroundColor = Color_Whiter;
    //是否自动滚动, 默认YES
    _bannerView.autoScroll = YES;
    //轮播图片的ContentMode, 默认为UIViewContentModeScaleToFill
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    //是否无限循环,默认YES: 滚动到第四张图就不再滚动了
    _bannerView.infiniteLoop = YES;
    //翻页的位置
    _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setBannerImgUriArray:(NSArray *)bannerImgUriArray {
    _bannerImgUriArray = bannerImgUriArray;
    if (_browserArray.count) [_browserArray removeAllObjects];
    if (_bannerImgUriArray.count) {
        NSMutableArray *bannerUrls = [NSMutableArray new];
        [_bannerImgUriArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *urlStr = [(NSDictionary *)obj objectForKey:@"aimgsrc"];
            [bannerUrls insertObject:[ToolUtil getNetImageURLStringWith:urlStr]?:urlStr atIndex:bannerUrls.count];
        }];
        _bannerView.imageURLStringsGroup = bannerUrls.copy;
        _sortLabel.hidden = NO;
        _sortLabel.text = [NSString stringWithFormat:@"1/%@", @(_bannerImgUriArray.count)];
    }else
        _sortLabel.hidden = YES;
}

- (NSArray <NSString *>*)bannerUrl {
    return _bannerView.imageURLStringsGroup;
}

- (void)setModel:(UserInfoModel *)model {
    _model = model;
    
    _editBtn.hidden = ![ToolUtil isEqualOwner:_model.id];
}

- (void)setStatus:(BOOL)status {
    _status = status;
    
    _editBtn.hidden = _status;
}

#pragma mark -
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (!self.bannerView.imageURLStringsGroup.count) return;
    
    if (!_browserArray.count) {
        [self.bannerView.imageURLStringsGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:obj];
            [_browserArray insertObject:data atIndex:_browserArray.count];
        }];
    }

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = _browserArray;
    browser.currentPage = index;
    [browser show];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectBannerWithIndex:)]) {
//        [self.delegate bannerView:self didSelectBannerWithIndex:index];
//    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    _sortLabel.text = [NSString stringWithFormat:@"%@/%@",@(index + 1), @(_bannerImgUriArray.count)];
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectedBack:)]) {
        [self.delegate bannerView:self didSelectedBack:sender];
    }
}

- (IBAction)clickToShare:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectedShare:)]) {
        [self.delegate bannerView:self didSelectedShare:sender];
    }
}

- (IBAction)clickToIDCard:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectedIDCard:)]) {
        [self.delegate bannerView:self didSelectedIDCard:sender];
    }
}

- (IBAction)clickToEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectedEdit:)]) {
        [self.delegate bannerView:self didSelectedEdit:sender];
    }
}


@end
