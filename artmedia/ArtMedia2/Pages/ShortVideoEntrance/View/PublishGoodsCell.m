//
//  PublishGoodsCell.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/25.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "PublishGoodsCell.h"

#import "GoodsImagesCell.h"
#import "VideoGoodsModel.h"

@interface PublishGoodsCell () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate ,AMTextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *imagesLabel;
//@property (weak, nonatomic) IBOutlet UILabel *mailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectView_height;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic ,strong) NSMutableArray <VideoGoodsImageModel *>*imagesData;

@end

@implementation PublishGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	_nameLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _classLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_introLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_dateLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	
	_imagesLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
	_imagesLabel.numberOfLines = 0;
	_imagesLabel.text = @"图片";
	
	_goodsNameTF.font = [UIFont addHanSanSC:15.0f fontType:0];
	_goodsNameTF.charCount = 24;
	_goodsNameTF.placeholder = @"请输入作品名称（必填）";
	_goodsNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
	[self addPlaceLeftMarginForTextField:_goodsNameTF];
    
    _goodsClassTF.font = [UIFont addHanSanSC:15.0f fontType:0];
    _goodsClassTF.placeholder = @"请选择作品分类（必选）";
    [self addPlaceLeftMarginForTextField:_goodsClassTF];
	
	_goodsIntroTV.font = [UIFont addHanSanSC:15.0f fontType:0];
	_goodsIntroTV.charCount = 300;
	_goodsIntroTV.placeholder = @"请输入作品介绍（如作品尺寸/材质等，必填）";
	[self addPlaceLeftMarginForTextField:_goodsNameTF];
	
	_goodsDateTF.font = [UIFont addHanSanSC:15.0f fontType:0];
	_goodsDateTF.placeholder = @"请设置作品创作日期（非必填）";
	[self addPlaceLeftMarginForTextField:_goodsDateTF];
	
//    _mailLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
//	_mailBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
//    [_mailBtn sizeToFit];
	
    _imagesData = [NSMutableArray new];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 15.0f;
    layout.minimumInteritemSpacing = 15.0f;
    layout.sectionInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
    
    _collectionView.backgroundColor = self.contentView.backgroundColor;
    
    _collectionView.collectionViewLayout = layout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.scrollEnabled = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsImagesCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([GoodsImagesCell class])];
	
//	_goodsDateTF.delegate = self;
	_goodsNameTF.delegate = self;
//    _goodsClassTF.delegate = self;
	_goodsIntroTV.ownerDelegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark -
- (void)reloadCollectView:(NSArray <VideoGoodsImageModel *>*)imagesData {
    if (_imagesData.count) [_imagesData removeAllObjects];
    [_imagesData addObjectsFromArray:imagesData];
    
    if (_imagesData.count == 0 || (_imagesData.count < 9 && [ToolUtil isEqualToNonNull:_imagesData.lastObject.imgsrc])) {
        [_imagesData addObject:[VideoGoodsImageModel new]];
    }
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    NSLog(@"self.collectionView.contentSize.height - %.2f",self.collectionView.contentSize.height);
}

- (void)setGoodsModel:(VideoGoodsModel *)goodsModel {
	_goodsModel = goodsModel;
    
    _goodsClassTF.text = [ToolUtil isEqualToNonNullKong:_goodsModel.classModel.secondcate.lastObject.scate_name];
    
    _goodsNameTF.text = [ToolUtil isEqualToNonNullKong:_goodsModel.name];
	_goodsIntroTV.text = [ToolUtil isEqualToNonNullKong:_goodsModel.describe];
    
    _goodsDateTF.text = [ToolUtil isEqualToNonNullKong:_goodsModel.good_created_time];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _imagesData.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = (self.collectionView.width - 15.0f*4)/3;
    return CGSizeMake(width, width);
}


// 返回cell内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	GoodsImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GoodsImagesCell class]) forIndexPath:indexPath];
	
    cell.currentImage = _imagesData[indexPath.item];

	cell.clickGoodsPickBlock = ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:pickGoodsIV:)]) {
            [self.delegate goodsCell:self pickGoodsIV:nil];
        }
	};
	cell.clickGoodsDeleteBlock = ^(NSIndexPath * _Nonnull indexPath) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:deleteGoodsIV:)]) {
            [self.delegate goodsCell:self deleteGoodsIV:indexPath.item];
        }
	};
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"collectionView.contentSize.height = %.2f",collectionView.contentSize.height);
    self.collectView_height.constant = collectionView.contentSize.height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:reloaload:)]) {
        [self.delegate goodsCell:self reloaload:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_goodsClassTF]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:selectGoodsClass:)]) {
            [self.delegate goodsCell:self selectGoodsClass:_goodsModel];
        }
        return NO;
    }
    if ([textField isEqual:_goodsDateTF]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:selectGoodsCreateDate:)]) {
            [self.delegate goodsCell:self selectGoodsCreateDate:_goodsModel];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:userInputResultWithinputStr:index:)]) {
        [self.delegate goodsCell:self userInputResultWithinputStr:textField.text index:0];
    }
	return YES;
}


#pragma mark - UITextViewDelegate
- (BOOL)amTextViewShouldEndEditing:(AMTextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:userInputResultWithinputStr:index:)]) {
        [self.delegate goodsCell:self userInputResultWithinputStr:textView.text index:1];
    }
	return YES;
}

- (IBAction)clickToGoodsClass:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:selectGoodsClass:)]) {
        [self.delegate goodsCell:self selectGoodsClass:_goodsModel];
    }
}

- (IBAction)clickToSelectDate:(AMButton *)sender {
	sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsCell:selectGoodsCreateDate:)]) {
        [self.delegate goodsCell:self selectGoodsCreateDate:_goodsModel];
    }
}

- (void)addPlaceLeftMarginForTextField:(UITextField *)textField {
	CGRect frame = textField.frame;
	frame.size.width = 8.0f;
	[textField setLeftView:[[UIView alloc]initWithFrame:frame]];
	[textField setLeftViewMode:UITextFieldViewModeAlways];
}

@end
