//
//  CZHChooseCoverController.m
//  saveCover
//
//  Created by 郭洪凯 on 2020/7/29.
//  Copyright © 2020年 郭洪凯. All rights reserved.
//

#import "CZHChooseCoverController.h"
#import <AVFoundation/AVFoundation.h>

#import "AMChooseCoverCell.h"

#import "TOCropViewController.h"
#import "PublishVideoViewController.h"


@interface CZHChooseCoverController ()<UICollectionViewDataSource, UICollectionViewDelegate,TOCropViewControllerDelegate,UINavigationControllerDelegate>
///
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
///图片显示
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet AMButton *leftBtn;
@property (weak, nonatomic) IBOutlet AMButton *rightBtn;
@property (weak, nonatomic) IBOutlet AMButton *finishBtn;

///总帧数
@property (nonatomic, assign) CMTimeValue timeValue;
///比例
@property (nonatomic, assign) CMTimeScale timeScale;
///照片数组
@property (nonatomic, strong) NSMutableArray *photoArrays;
 
@property (nonatomic, assign)CGFloat currentTime;

@end

@implementation CZHChooseCoverController

- (NSMutableArray *)photoArrays {
    if (!_photoArrays) {
        _photoArrays = [NSMutableArray array];
    }
    return _photoArrays;
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgColorStyle = AMBaseBackgroundColorStyleBlack;
    
    [self setUpView];
    
    [self getVideoTotalValueAndScale];
}

#pragma mark -
- (void)setUpView {
    self.finishBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    [self.finishBtn setBackgroundColor:[UIColorFromRGB(0x65676D) colorWithAlphaComponent:0.3]];
    self.leftBtn.titleLabel.font = [UIFont addHanSanSC:17.0 fontType:2];
    self.rightBtn.titleLabel.font = [UIFont addHanSanSC:15.0 fontType:0];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.collectionView.height, self.collectionView.height);
    layout.minimumInteritemSpacing = CGFLOAT_MIN;
    layout.minimumLineSpacing = 5.0f;
    layout.sectionInset = UIEdgeInsetsMake(1.0, 5.0, 1.0, 0.0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AMChooseCoverCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AMChooseCoverCell class])];
}

- (void)getVideoTotalValueAndScale {
    AVURLAsset * asset = [AVURLAsset assetWithURL:self.videoPath];
    CMTime  time = [asset duration];
    self.timeValue = time.value;
    self.timeScale = time.timescale;
    
    if (time.value < 1) {
        [SVProgressHUD showError:@"解析视频路径出错，请重试" completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:self.videoPath options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    
    float currentTime = CMTimeGetSeconds(time);
    self.currentTime = currentTime;
    NSInteger itemCount=currentTime/1;
    long long baseCount = time.value / (currentTime/1);
    //取出PHOTP_COUNT张图片,存放到数组，用于collectionview
    for (NSInteger i = 0 ; i < itemCount; i++) {
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(i * baseCount, time.timescale) actualTime:NULL error:&error];
        {
            UIImage *image = [UIImage imageWithCGImage:img];
            
            [self.photoArrays addObject:image];
        }
        ///释放内存
        CGImageRelease(img);
    }
    //手动选取第一张
    [self chooseWithTime:[NSIndexPath indexPathForItem:0 inSection:0]];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AMChooseCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMChooseCoverCell class]) forIndexPath:indexPath];
    cell.coverImage = self.photoArrays[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self chooseWithTime:indexPath];
}

- (void)chooseWithTime:(NSIndexPath *)indexPath {
    self.imageView.image = self.photoArrays[indexPath.item];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark -
- (IBAction)clickToBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)senderbuttonClick:(id)sender {
    //封面图片回调
    [self clickToCrop:self.imageView.image];
}

//相册选择
- (IBAction)rightAction:(AMButton *)sender {
    @weakify(self);
    [ToolUtil showInControllerWithoutUpload:self photoOfMax:1 withType:AMImageSelectedMeidaTypePhoto completion:^(NSArray * _Nullable images) {
        if (images && images.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self clickToCrop:images.lastObject];
            });
        }
    }];
}

- (void)clickToCrop:(UIImage *)image {
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:image];
    cropController.delegate = self;
    
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
    /// 隐藏toolbar旋转按钮
    cropController.rotateButtonsHidden = YES;
    cropController.aspectRatioLockEnabled = YES;
    
    [self presentViewController:cropController animated:YES completion:nil];
}

#pragma mark  -TOCropViewControllerDelegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    if (_coverImageBlock)  _coverImageBlock(image);
    UIViewController *vc = self.presentingViewController;
    //ReadBookController要跳转的界面
    while ([vc isKindOfClass:[PublishVideoViewController class]]) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
