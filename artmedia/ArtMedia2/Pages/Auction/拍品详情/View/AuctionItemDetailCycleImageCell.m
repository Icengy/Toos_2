//
//  AuctionItemDetailCycleImageCell.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionItemDetailCycleImageCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <YBImageBrowser/YBImageBrowser.h>


@interface AuctionItemDetailCycleImageCell ()<SDCycleScrollViewDelegate>

@property (nonatomic , strong) SDCycleScrollView *bannerView2;
@property (nonatomic , strong) NSMutableArray <NSString *>*imageUrls;
@property (nonatomic , strong) NSMutableArray *YBIBimageUrls;
@property (weak, nonatomic) IBOutlet UIView *bannerBackView;


@end
@implementation AuctionItemDetailCycleImageCell

- (NSMutableArray<NSString *> *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [[NSMutableArray alloc] init];
    }
    return _imageUrls;
}
- (NSMutableArray<NSURL *> *)YBIBimageUrls{
    if (!_YBIBimageUrls) {
        _YBIBimageUrls = [[NSMutableArray alloc] init];
    }
    return _YBIBimageUrls;
}

- (SDCycleScrollView *)bannerView2{
    if (!_bannerView2) {
        _bannerView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _bannerView2.pageDotColor = Color_Whiter;
        _bannerView2.hidesForSinglePage = NO;
        _bannerView2.currentPageDotColor = Color_MainBg;
        _bannerView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView2.autoScrollTimeInterval = 3.0;
//        _bannerView2.placeholderImage = ImageNamed(@"PersonalDefaultHeader");
        
        //背景色
        _bannerView2.backgroundColor = RGB(240, 240, 240);
        //是否自动滚动, 默认YES
        _bannerView2.autoScroll = YES;
        //轮播图片的ContentMode, 默认为UIViewContentModeScaleToFill
        _bannerView2.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        //是否无限循环,默认YES: 滚动到第四张图就不再滚动了
        _bannerView2.infiniteLoop = YES;
        [self.bannerBackView addSubview:_bannerView2];
    }
    return _bannerView2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.bannerView.delegate = self;
////    _bannerView.pageControlDotSize = CGSizeMake(10, 10);
//    self.bannerView.pageDotColor = Color_Whiter;
//    self.bannerView.hidesForSinglePage = NO;
//    self.bannerView.currentPageDotColor = Color_MainBg;
//    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    self.bannerView.autoScrollTimeInterval = 3.0;
//    self.bannerView.placeholderImage = ImageNamed(@"PersonalDefaultHeader");
//
//    //背景色
//    self.bannerView.backgroundColor = RGB(240, 240, 240);
//    //是否自动滚动, 默认YES
//    self.bannerView.autoScroll = YES;
//    //轮播图片的ContentMode, 默认为UIViewContentModeScaleToFill
//    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
//    //是否无限循环,默认YES: 滚动到第四张图就不再滚动了
//    self.bannerView.infiniteLoop = YES;
//    //翻页的位置
//    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//    // Initialization code
}

- (void)setModel:(AuctionItemDetailModel *)model{
    _model = model;
    if (model) {
        [self.imageUrls removeAllObjects];
        [self.YBIBimageUrls removeAllObjects];
        [model.opusImagesList enumerateObjectsUsingBlock:^(OpusImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *url = [NSString stringWithFormat:@"%@/%@",IMAGE_JAVA_HOST,obj.image];
            [self.imageUrls addObject:url];
            
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:url];
    //        data.projectiveView = [self viewAtIndex:idx];
            [self.YBIBimageUrls addObject:data];
        }];
    }
    self.bannerView2.imageURLStringsGroup = [self.imageUrls mutableCopy];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bannerView2.frame = self.bannerBackView.bounds;
}

- (IBAction)backClick:(AMButton *)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (IBAction)clickToShare:(id)sender {
    if (self.shareBlock) self.shareBlock();
}


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.YBIBimageUrls;
    browser.currentPage = index;
    [browser show];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
@end
