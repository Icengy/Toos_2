//
//  SearchNormalViewController.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "SearchNormalViewController.h"
#import "SKTagView.h"

@interface SearchNormalViewController ()
@property (nonatomic ,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic ,strong) SKTagView *tagView;
@property (nonatomic ,weak) IBOutlet UIView *topLine;
@end

@implementation SearchNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
	
	[self.view addSubview:self.tagView];
	// 点击事件回调
	@weakify(self);
	self.tagView.didTapTagAtIndex = ^(NSUInteger idx){
		NSLog(@"点击了第%ld个",idx);
		@strongify(self);
		if (self.tagClickBlock) self.tagClickBlock(self.tagArray[idx]);
	};
	
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	[self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.equalTo(self.view);
		make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
	}];
}

#pragma mark -
- (void)hideSubView:(BOOL)hidden {
	self.titleLabel.hidden = hidden;
	self.tagView.hidden = hidden;
}

#pragma mark -
- (void)setTagArray:(NSArray *)tagArray {
	[self.tagView removeAllTags];
	_tagArray = tagArray;
	[_tagArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		// 初始化标签
		SKTag *tag = [[SKTag alloc] initWithText:_tagArray[idx]];
		// 标签相对于自己容器的上左下右的距离
		tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
		// 弧度
		tag.cornerRadius = 3.0f;
		// 字体
		tag.font = [UIFont addHanSanSC:15.0f fontType:0];
		// 边框宽度
		tag.borderWidth = 0;
		// 背景
		tag.bgColor = RGB(245, 245, 245);
		// 边框颜色
		tag.borderColor = RGB(245, 245, 245);
		// 字体颜色
		tag.textColor = Color_Black;
		// 是否可点击
		tag.enable = YES;
		// 加入到tagView
		[self.tagView addTag:tag];
	}];
}
#pragma mark -
- (SKTagView *)tagView {
	if (!_tagView) {
		_tagView = [[SKTagView alloc] init];
		// 整个tagView对应其SuperView的上左下右距离
		_tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
		// 上下行之间的距离
		_tagView.lineSpacing = 10;
		// item之间的距离
		_tagView.interitemSpacing = 20;
		//固定高度
		_tagView.regularHeight = ADAPTATIONRATIOVALUE(64.0f);
		// 最大宽度
		_tagView.preferredMaxLayoutWidth = K_Width;
	}return _tagView;
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
