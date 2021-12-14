//
//  GiftPresentViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/26.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "GiftPresentViewController.h"

#import "AMPayViewController.h"
#import "YiBRechargeViewController.h"

#import "VideoListModel.h"

#import "GiftPresentCollectionViewCell.h"

@interface GiftPresentViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, AMPayDelegate>

@property (weak, nonatomic) IBOutlet UIView *giftDemoView;
@property (weak, nonatomic) IBOutlet UIView *giftCountCarrier;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthConstranit;

@property (weak, nonatomic) IBOutlet AMButton *minsCountBtn;
@property (weak, nonatomic) IBOutlet AMTextField *inputTF;
@property (weak, nonatomic) IBOutlet AMButton *plusCountBtn;

@property (weak, nonatomic) IBOutlet AMButton *totalPriceLabel;
@property (weak, nonatomic) IBOutlet AMButton *presentBtn;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic ,assign) NSInteger giftCount;
@end

@implementation GiftPresentViewController {
	NSInteger _totalPrice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    self.view.backgroundColor = UIColor.clearColor;
	
    _collectionViewWidthConstranit.constant = (80.0f*2+15.0f*3);
	
	_inputTF.font = [UIFont addHanSanSC:15.0f fontType:0];
	_inputTF.delegate = self;
	
	_minsCountBtn.enabled = NO;
	_plusCountBtn.enabled = YES;
	
    _totalPriceLabel.titleLabel.font = [UIFont addHanSanSC:21.0f fontType:0];
	_presentBtn.layer.cornerRadius = _presentBtn.height/2;
    
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80.0f, 30.0f);
    CGFloat marginV = (self.collectionView.height - layout.itemSize.height *3)/5;
	layout.minimumLineSpacing = marginV;
	layout.minimumInteritemSpacing = 15.0f;
    layout.sectionInset = UIEdgeInsetsMake(marginV, 15.0f, marginV, 15.0f);
	
	_collectionView.collectionViewLayout = layout;
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	
	[_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GiftPresentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([GiftPresentCollectionViewCell class])];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _totalPrice = self.selectedIndexPath.item *10;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[_inputTF resignFirstResponder];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	GiftPresentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GiftPresentCollectionViewCell class]) forIndexPath:indexPath];
	
	cell.indexPath = indexPath;
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedIndexPath = indexPath;
}

#pragma mark -
- (void)payViewController:(BaseViewController *)payViewController didSelectPayVirtualWithNeedRecharge:(BOOL)needRecharge {
    if (needRecharge) {
        [payViewController dismissViewControllerAnimated:YES completion:^{
            YiBRechargeViewController *rechargeVC = [[YiBRechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }];
    }
}

#pragma mark -
- (IBAction)clickToPresent:(id)sender {
    AMPayViewController *payVC = [[AMPayViewController alloc] init];
    payVC.delegate = self;
    payVC.payStyle = AMAwakenPayStyleConsumption;
    payVC.priceStr = StringWithFormat(@(_totalPrice));
    [self.navigationController presentViewController:payVC animated:YES completion:nil];
}

- (IBAction)clickToMins:(AMButton *)sender {
	self.giftCount --;
}

- (IBAction)clickToPlus:(AMButton *)sender {
	self.giftCount ++;
}

- (void)textFieldDidChange:(UITextField *)textField {
	if (textField.text.integerValue < 1) {
		[SVProgressHUD showError:@"数量最少为1" completion:^{
			[self fillCountData];
		}];
		return;
	}
	self.giftCount = textField.text.integerValue;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (textField.text.integerValue < 1) {
		[SVProgressHUD showError:@"数量最少为1" completion:^{
			[self fillCountData];
		}];
		return NO;
	}
	self.giftCount = textField.text.integerValue;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[_inputTF resignFirstResponder];
	return YES;
}

#pragma mark -
- (void)fillCountData {
	NSInteger count = _giftCount;
	self.giftCount = count;
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
	_selectedIndexPath = selectedIndexPath;
	NSLog(@"_selectedIndexPath = %@", _selectedIndexPath);
	[self.collectionView selectItemAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
	switch (_selectedIndexPath.row) {
		case 0:
			self.giftCount = 1;
			break;
		case 1:
			self.giftCount = 3;
			break;
		case 2:
			self.giftCount = 5;
			break;
		case 3:
			self.giftCount = 10;
			break;
		case 4:
			self.giftCount = 15;
			break;
			
		default: {
			
			[UIView animateWithDuration:0.33 animations:^{
				self.collectionView.alpha -= 0.01;
				self.giftCountCarrier.alpha += 1.0;
			} completion:^(BOOL finished) {
				self.collectionView.hidden = YES;
				self.giftCountCarrier.hidden = NO;
				self.giftCount = 1;
                [self.collectionView reloadData];
			}];
			
			break;
		}
	}
}

- (void)setGiftCount:(NSInteger)giftCount {
	_giftCount = giftCount;
	
	[_inputTF resignFirstResponder];
	
	if (_giftCount <= 1) {
		_minsCountBtn.enabled = NO;
	}else
		_minsCountBtn.enabled = YES;
	
    _totalPrice = _giftCount *10;
	_inputTF.text = [NSString stringWithFormat:@"%@",@(_giftCount)];
	
    [_totalPriceLabel setTitle:StringWithFormat(@(_totalPrice)) forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
