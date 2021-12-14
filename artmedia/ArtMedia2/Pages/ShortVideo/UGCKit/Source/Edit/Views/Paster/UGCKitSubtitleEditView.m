//
//  UGCKitSubtitleEditView.m
//  UGCKit
//
//  Created by icnengy on 2020/7/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "UGCKitSubtitleEditView.h"

#import "UGCKit_UIViewAdditions.h"
#import "UGCKitColorMacro.h"
#import "UGCKitVideoInfo.h"

#import "UGCKitFontUtil.h"

#import "UGCKitSubtitleFontNameCollectionCell.h"
#import "UGCKitSubtitleTextColorsCollectionCell.h"

@implementation UGCKitSubtitleInfo

@end

@interface UGCKitSubtitleEditView () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UGCKitTheme * theme;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *confirmBtn;

@property (strong, nonatomic) UICollectionView *colorCollectionView;
@property (strong, nonatomic) UICollectionView *fontCollectionView;

@property (strong, nonatomic) UILabel *fontSizeTitleLabel;
@property (strong, nonatomic) UISlider *slider;

@end

@implementation UGCKitSubtitleEditView {
    NSMutableArray <UIColor *>*_colorsArray;
    NSMutableArray <NSDictionary *>*_fontsArray;
    NSIndexPath *_selectColorIndexPath;
    NSIndexPath *_selectFontIndexPath;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColorFromRGB(0x1A1A1A);
    }return _contentView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, 0, 26.0f, 26.0f);
        [_cancelBtn setImage:_theme.editSubtitleCancelIcon forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    }return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(0, 0, 26.0f, 26.0f);
        [_confirmBtn setImage:_theme.editSubtitleConfirmIcon forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    }return _confirmBtn;
}

- (UICollectionView *)colorCollectionView {
    if (!_colorCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44.0f, 44.0f);
        layout.sectionInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 15.0f;
        layout.minimumInteritemSpacing = 0.0f;
        
        _colorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.ugckit_width, 44.0f) collectionViewLayout:layout];
        _colorCollectionView.delegate = self;
        _colorCollectionView.dataSource = self;
        _colorCollectionView.backgroundColor = self.contentView.backgroundColor;
        _colorCollectionView.showsVerticalScrollIndicator = NO;
        _colorCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_colorCollectionView registerClass:[UGCKitSubtitleTextColorsCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([UGCKitSubtitleTextColorsCollectionCell class])];
    }return _colorCollectionView;
}

- (UICollectionView *)fontCollectionView {
    if (!_fontCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60.0f, 44.0f);
        layout.sectionInset = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 15.0f;
        layout.minimumInteritemSpacing = 0.0f;
        
        _fontCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.ugckit_width, 44.0f) collectionViewLayout:layout];
        _fontCollectionView.delegate = self;
        _fontCollectionView.dataSource = self;
        _fontCollectionView.backgroundColor = self.contentView.backgroundColor;
        _fontCollectionView.showsVerticalScrollIndicator = NO;
        _fontCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_fontCollectionView registerClass:[UGCKitSubtitleFontNameCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([UGCKitSubtitleFontNameCollectionCell class])];
    }return _fontCollectionView;
}

- (UILabel *)fontSizeTitleLabel {
    if (!_fontSizeTitleLabel) {
        _fontSizeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 30.0f, 30.0f)];
        _fontSizeTitleLabel.text = @"字号";
        _fontSizeTitleLabel.textColor = UIColor.whiteColor;
        _fontSizeTitleLabel.textAlignment = NSTextAlignmentLeft;
        [_fontSizeTitleLabel sizeToFit];
        
    }return _fontSizeTitleLabel;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.ugckit_width - 30.0f - self.fontSizeTitleLabel.ugckit_width, 20.0f)];
        _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_slider setThumbImage:_theme.sliderThumbImage forState:UIControlStateNormal];
        _slider.minimumTrackTintColor = UIColorFromRGB(0xE22020);
        _slider.maximumTrackTintColor = UIColorFromRGB(0x333333);
        
        _slider.minimumValue = 10.0f;
        _slider.maximumValue = UGCKitMaxChangedFontSize;
        _slider.value = 13.0f;
        [_slider addTarget:self action:@selector(_sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }return _slider;
}

#pragma mark -
+ (UGCKitSubtitleEditView *)shareInstanceWithTheme:(UGCKitTheme *)theme {
    return [[UGCKitSubtitleEditView alloc] initWithTheme:theme];
}

- (instancetype) initWithTheme:(UGCKitTheme *)theme {
    if (self = [super init]) {
        _theme = theme;
        
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = UIColor.clearColor;
        
        [self loadData];
        [self setupUIs];
    }return self;
}

- (void)loadData {
    _fontsArray = @[].mutableCopy;
    
    /// 默认字体
    [_fontsArray addObject:@{@"name":@"默认", @"filename":@"" , @"path":@""}];
    
   NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"UGCSubtitleFont" ofType:@"bundle"];
    NSString *jsonString = [NSString stringWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"config.json"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dic = [self dictionaryWithJsonString:jsonString];
    if ([dic objectForKey:@"fontList"]) {
        for (NSDictionary *fontdic in dic[@"fontList"]) {
            NSMutableDictionary *fontdics = fontdic.mutableCopy;
            [fontdics setObject:[bundlePath stringByAppendingFormat:@"/%@",fontdic[@"filename"]] forKey:@"path"];
            [_fontsArray addObject:fontdics.copy];
        }
    }
    _colorsArray = @[].mutableCopy;
    NSString *colorsBundlePath = [[NSBundle mainBundle] pathForResource:@"subtitleColors" ofType:@"json"];
    NSString *colorJsonString = [NSString stringWithContentsOfFile:colorsBundlePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *colordic = [self dictionaryWithJsonString:colorJsonString];
    if ([colordic objectForKey:@"colorList"]) {
        for (NSDictionary *colorValue in colordic[@"colorList"]) {
            UIColor *color = RGBA([[colorValue objectForKey:@"R"] floatValue], [[colorValue objectForKey:@"G"] floatValue], [[colorValue objectForKey:@"B"] floatValue], [[colorValue objectForKey:@"A"] floatValue]);
            [_colorsArray addObject:color];
        }
    }
    
    _selectFontIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    _selectColorIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
}

- (void)setupUIs {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClose)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.colorCollectionView];
    [self.contentView addSubview:self.fontCollectionView];
    
    [self.contentView addSubview:self.fontSizeTitleLabel];
    [self.contentView addSubview:self.slider];
}

-  (void)setTextThemeInfo:(UGCKitVideoTextThemeInfo *)textThemeInfo {
    _textThemeInfo = textThemeInfo;
    
    [_fontsArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([[obj objectForKey:@"path"] isEqualToString:_textThemeInfo.fontPath]) {
           _selectFontIndexPath = [NSIndexPath indexPathForItem:idx inSection:0];
           *stop = YES;
        }
    }];
    [self.fontCollectionView selectItemAtIndexPath:_selectFontIndexPath animated:YES scrollPosition:(UICollectionViewScrollPositionRight)];
    
    CGFloat fontsize = _textThemeInfo.fontSize;
    if (_textThemeInfo.fontSize < 10.0f) fontsize = 13.0f;
    if (_textThemeInfo.fontSize > UGCKitMaxChangedFontSize) fontsize = UGCKitMaxChangedFontSize;
    
    self.slider.value = fontsize;
    
    if ([_colorsArray containsObject:_textThemeInfo.textColor]) {
        _selectColorIndexPath = [NSIndexPath indexPathForItem:[_colorsArray indexOfObject:_textThemeInfo.textColor] inSection:0];
    }
    [self.colorCollectionView selectItemAtIndexPath:_selectColorIndexPath animated:YES scrollPosition:(UICollectionViewScrollPositionRight)];
}

- (void)setMaxFontSize:(CGFloat)maxFontSize {
    _maxFontSize = maxFontSize;
    _slider.maximumValue = _maxFontSize;
}

- (void)setCurrentFontSize:(CGFloat)currentFontSize {
    _currentFontSize = currentFontSize;
    _slider.value = _currentFontSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat safeBottom = 0.0f;
    if (@available(iOS 11.0, *)) {
        safeBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    CGFloat height = safeBottom + 10.0f + self.cancelBtn.ugckit_height + 20.0f + self.colorCollectionView.ugckit_height + 35.0f + self.slider.ugckit_height + 35.0f +  self.fontCollectionView.ugckit_height + 15.0f ;
    self.contentView.frame = CGRectMake(0, self.ugckit_height - height, self.ugckit_width, height);
    
    [self.fontCollectionView setUgckit_y:15.0f];
    
    [self.slider setUgckit_x:CGRectGetMaxX(self.fontSizeTitleLabel.frame)];
    [self.slider setUgckit_y:(35.0f + CGRectGetMaxY(self.fontCollectionView.frame))];
    [self.slider setUgckit_width:(self.ugckit_width - 15.0f - self.fontSizeTitleLabel.ugckit_width)];
    
    self.fontSizeTitleLabel.center = CGPointMake(self.fontSizeTitleLabel.center.x, self.slider.center.y);
    
    [self.colorCollectionView setUgckit_y:(35.0f + CGRectGetMaxY(self.slider.frame))];
    
    [self.cancelBtn setUgckit_y:(20.0f + CGRectGetMaxY(self.colorCollectionView.frame))];
    [self.cancelBtn setUgckit_x:15.0f];
    
    [self.confirmBtn setUgckit_y:self.cancelBtn.ugckit_y];
    [self.confirmBtn setUgckit_x:self.ugckit_width - self.confirmBtn.ugckit_width - 15.0f];
    
}

- (void)onShow {
    if (!self) return;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^ {
    } completion:nil];
}

- (void)onClose {
    [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^ {
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)_sliderValueDidChanged:(UISlider *)slider {
//    NSLog(@"_sliderValueDidChanged = %.0f",slider.value);
    _textThemeInfo.fontSize = slider.value;
    /// 字体大小改变
    if (self.delegate && [self.delegate respondsToSelector:@selector(editView:textThemeInfoChangedWithType:withValue:)]) {
        [self.delegate editView:self textThemeInfoChangedWithType:1 withValue:[NSNumber numberWithFloat:_textThemeInfo.fontSize]];
    }
}

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.fontCollectionView) {
        return _fontsArray.count;
    }
    if (collectionView == self.colorCollectionView) {
        return _colorsArray.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.fontCollectionView) {
        UGCKitSubtitleFontNameCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UGCKitSubtitleFontNameCollectionCell class]) forIndexPath:indexPath];
        
        cell.fontDict = _fontsArray[indexPath.item];
        return cell;
    }
    
    UGCKitSubtitleTextColorsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UGCKitSubtitleTextColorsCollectionCell class]) forIndexPath:indexPath];
    
    cell.color = _colorsArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.colorCollectionView) {
        _selectColorIndexPath = indexPath;
        _textThemeInfo.textColor = _colorsArray[indexPath.item];
        
        /// 文本颜色改变
        if (self.delegate && [self.delegate respondsToSelector:@selector(editView:textThemeInfoChangedWithType:withValue:)]) {
            [self.delegate editView:self textThemeInfoChangedWithType:2 withValue:_textThemeInfo.textColor];
        }
    }
    if (collectionView == self.fontCollectionView) {
        _selectFontIndexPath = indexPath;
        _textThemeInfo.fontPath = [_fontsArray[indexPath.item] objectForKey:@"path"];
        
        /// 字体类型改变
        if (self.delegate && [self.delegate respondsToSelector:@selector(editView:textThemeInfoChangedWithType:withValue:)]) {
            [self.delegate editView:self textThemeInfoChangedWithType:0 withValue:_textThemeInfo.fontPath];
        }
    }
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark -
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
