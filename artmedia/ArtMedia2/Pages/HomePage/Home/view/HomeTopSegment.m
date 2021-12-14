//
//  HomeTopSegment.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/12.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "HomeTopSegment.h"

@interface HomeTopSegment () {
	NSInteger _itemCounts;//控件的总数量
	NSArray *_titleArray;//存放标题的数组
	
	float _itemWidth;
	UIView *_selectBgView;
}
@end

@implementation HomeTopSegment

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
+ (HomeTopSegment *)shareInstanceWithSize:(CGSize)size itemArray:(NSArray *)itemArray {
	HomeTopSegment *topsegmengt = [[HomeTopSegment alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) itemArray:itemArray];
	return topsegmengt;
}

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray *)itemArray {
	if (self = [super initWithFrame:frame]) {
		_titleArray = itemArray;
		_itemCounts = _titleArray.count;
		_itemWidth = frame.size.width/_itemCounts;
		[self initSubViews];
	}return self;
}

#pragma mark -
- (void)initSubViews {
	//循环创建按钮
	for (int i = 0; i < _itemCounts; i++) {
		AMButton *button  = [[AMButton alloc]initWithFrame:CGRectMake(i *_itemWidth, 0, _itemWidth, self.height)];
		[self addSubview:button];
		
		//设置button的字
		[button setTitle:_titleArray[i] forState:UIControlStateNormal];
		//设置button的字颜色
		[button setTitleColor:RGB(122, 129, 153) forState:UIControlStateNormal];
		[button setTitleColor:RGB(22, 21, 26) forState:UIControlStateSelected];
		//设置字体大小
		button.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
		//设置居中显示
		button.titleLabel.textAlignment = NSTextAlignmentCenter;
		//设置tag值
		button.tag = 1000 + i;
		//添加点击事件
		[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
		//如果是第一个，默认被选中
		if (i == 0) {
			button.selected = YES;
			button.titleLabel.font = [UIFont addHanSanSC:21.0f fontType:0];
		}
	}
	
	//添加一个select
	_selectBgView = [[UIView alloc]initWithFrame:CGRectMake(_itemWidth*3/8, ViewHeightOf(self)- 5, _itemWidth/4, 3)];
	_selectBgView.backgroundColor = Color_MainBg;
	_selectBgView.layer.cornerRadius = 1.5;
	[self addSubview:_selectBgView];
}


-(void)buttonAction:(UIButton *)button {
	if (button.selected) return;
	
	//当button被点击，所有的button都设为未选中状态
	for (UIView *view in self.subviews) {
		if ([view isKindOfClass:[UIButton class]]) {
			UIButton *subButton = (UIButton*)view;
			subButton.selected = NO;
			subButton.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
		}
	}
	//然后将选中的这个button变为选中状态
	button.selected = YES;
	if (!_sameTitleSize) {
		button.titleLabel.font = [UIFont addHanSanSC:21.0f fontType:2];
	}
	//通过当前的tag值设置select的位置
	NSInteger index = button.tag - 1000;
	if (_returnBlock) _returnBlock(index);
	
	[UIView animateWithDuration:.3 animations:^{
		CGPoint origin = _selectBgView.origin;
//		origin.x = index *_itemWidth + _itemWidth*2/5;
		if (origin.x > _itemWidth ) {//向左滑动
			origin.x -= _itemWidth;
		}else {
			origin.x += _itemWidth;
		}
		_selectBgView.origin = origin;
		
//		_selectBgView.frame = CGRectMake(index*_itemWidth+_itemWidth*2/5, _selectBgView.frame.origin.y, _selectBgView.frame.size.width, _selectBgView.frame.size.height);
	}];
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex {
	_currentSelectedIndex = currentSelectedIndex;
	
	for (UIView *view in self.subviews) {
		if ([view isKindOfClass:[UIButton class]]) {
			UIButton *subButton = (UIButton*)view;
			subButton.selected = NO;
			subButton.titleLabel.font = [UIFont addHanSanSC:18.0f fontType:0];
		}
	}
	NSInteger index = _currentSelectedIndex + 1000;
	UIButton *button = (UIButton *)[self viewWithTag:index];
	button.selected = YES;
	if (!_sameTitleSize) {
		button.titleLabel.font = [UIFont addHanSanSC:21.0f fontType:2];
	}

	[UIView animateWithDuration:.3 animations:^{
		CGPoint origin = _selectBgView.origin;
//		origin.x = index *_itemWidth + _itemWidth*2/5;
		if (origin.x > _itemWidth ) {//向左滑动
			origin.x -= _itemWidth;
		}else {
			origin.x += _itemWidth;
		}
		_selectBgView.origin = origin;
	}];
}

#pragma mark -
- (void)setSameTitleSize:(BOOL)sameTitleSize {
	_sameTitleSize = sameTitleSize;
//	if (_sameTitleSize) {
	for (UIView *view in self.subviews) {
		if ([view isKindOfClass:[UIButton class]]) {
			UIButton *subButton = (UIButton*)view;
			subButton.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
		}
	}
//	}
}

@end
