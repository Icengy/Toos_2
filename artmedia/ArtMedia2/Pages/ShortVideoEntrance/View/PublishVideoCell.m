//
//  PublishVideoCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PublishVideoCell.h"

#import "PublishChannelCollectionCell.h"

#import "VideoListModel.h"

@interface PublishVideoCell () <AMTextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet AMButton *reloadBtn;
@property (weak, nonatomic) IBOutlet AMButton *editBtn;

@property (nonatomic ,strong) VideoColumnModel *selectChannel;
@end

@implementation PublishVideoCell {
    NSArray <VideoColumnModel *>*_columnArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	
	_videoIntroView.charCount = 50;
	_videoIntroView.placeholder = @"填写视频的简介（必填，50字以内）";
	_videoIntroView.ownerDelegate = self;
	_videoIntroView.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    _channelLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    _editBtn.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    [_editBtn setBackgroundColor:[Color_Black colorWithAlphaComponent:0.3]];
    
    if (_columnArray) _columnArray = @[];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(60.f, 30.f);
    flowLayout.minimumLineSpacing = CGFLOAT_MIN;
    flowLayout.minimumInteritemSpacing = ADAptationMargin;
    CGFloat margin = (_collectionView.height-flowLayout.itemSize.height)/2;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, 0.0f, margin, 0.0f);
    
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PublishChannelCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PublishChannelCollectionCell class])];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
}

- (BOOL)amTextViewShouldEndEditing:(AMTextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCell:introTextChanged:)]) {
        [self.delegate videoCell:self introTextChanged:textView.text];
    }
	return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateColumn:(NSArray <VideoColumnModel *>*_Nullable)columnArray withSelectColumn:(VideoColumnModel *_Nullable)selectColumn {
    _columnArray = columnArray;
    if (!_columnArray.count) {
        self.collectionView.hidden = YES;
        self.reloadBtn.hidden = NO;
        return;
    }
    self.reloadBtn.hidden = YES;
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
    
    self.selectChannel = selectColumn;
}

- (void)setSelectChannel:(VideoColumnModel *)selectChannel {
    _selectChannel = selectChannel;
    if (_selectChannel && _columnArray) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:[_columnArray indexOfObject:_selectChannel] inSection:0] animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
    }
}

- (void)setPublishVideoCellWithImage:(id)cutImageUrl videoIntro:(NSString *)videoIntro {
    if ([cutImageUrl isKindOfClass:[UIImage class]]) {
        _videoCutIV.contentMode = UIViewContentModeScaleAspectFit;
        _videoCutIV.image = cutImageUrl?:ImageNamed(@"videoCoverHold");
    }else {
        [_videoCutIV am_setImageWithURL:cutImageUrl placeholderImage:ImageNamed(@"videoCoverHold") contentMode:UIViewContentModeScaleAspectFit];
    }
	_videoIntroView.text = [ToolUtil isEqualToNonNullKong:videoIntro];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _columnArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublishChannelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PublishChannelCollectionCell class]) forIndexPath:indexPath];
    
    cell.channel = _columnArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
    _selectChannel = _columnArray[indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCell:columnChanged:)]) {
        [self.delegate videoCell:self columnChanged:_selectChannel];
    }
}


- (IBAction)clickToReload:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCell:reloadWithColumn:)]) {
        [self.delegate videoCell:self reloadWithColumn:sender];
    }
}

- (IBAction)clickToEdit:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCell:editVideoCover:)]) {
        [self.delegate videoCell:self editVideoCover:sender];
    }
}

@end
