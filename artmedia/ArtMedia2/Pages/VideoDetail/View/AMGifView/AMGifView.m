//
//  AMGifView.m
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/11/27.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import "AMGifView.h"

@interface AMGifView ()
@property (nonatomic ,strong) UIImageView *gifIV;
@property (nonatomic ,strong) UILabel *countLabel;
@end

@implementation AMGifView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (AMGifView *)shareInstance {
	AMGifView *instance = [[AMGifView alloc] init];
	return instance;
}

- (instancetype)init {
	if (self = [super init]) {
		self.alpha = 0.01;
		self.backgroundColor = [UIColor clearColor];
		self.frame = [UIApplication sharedApplication].keyWindow.bounds;
		[self addSubview:self.gifIV];
		[self addSubview:self.countLabel];
	}return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	self.gifIV.bottom = self.centerY;
	self.gifIV.centerX = self.centerX;
	
	self.countLabel.y = self.gifIV.bottom;
	self.countLabel.centerX = self.centerX;
}

#pragma mark -
- (void)showGifView:(NSString *_Nullable)gifUrlStr count:(NSInteger)count {
	[[UIApplication sharedApplication].keyWindow addSubview:self];
	
	if ([ToolUtil isEqualToNonNull:gifUrlStr ])
		self.gifIV.animationImages = [self getGifArray:gifUrlStr];
	
	[self beginAnimation];
	self.countLabel.text = [NSString stringWithFormat:@"您赠送了%@朵花", @(count)];
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^ {
		self.alpha = 1.0;
		NSLog(@"in animate start");
	} completion:^(BOOL finished) {
		NSLog(@"showGifView in animate completion");
		[self performSelector:@selector(hideEnterance) withObject:nil afterDelay:2.0f];
	}];
}

- (void)hideEnterance {
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^ {
		self.alpha = 0.01;
		NSLog(@"out animate start");
	}completion:^(BOOL finished) {
		NSLog(@"out animate completion");
		[self endAnimation];
		[self removeFromSuperview];
	}];
}

- (void)beginAnimation {
	if (self.gifIV.isAnimating) {
		/// 先暂停再结束是因为有可能属性表现的是正在动画,但是实际上是没做动画.直接调用startAnimation是不会做动画的
		[self.gifIV stopAnimating];
		[self.gifIV startAnimating];
	} else {
		[self.gifIV startAnimating];
	}
}

- (void)endAnimation {
	if (!self.gifIV.isAnimating) {
		/// 先开始再结束是因为有可能属性表现的是没做动画,但是实际上是正在动画.直接调用stopAnimation是不会停止做动画的
		[self.gifIV startAnimating];
		[self.gifIV stopAnimating];
	} else {
		[self.gifIV startAnimating];
	}
}

#pragma mark -
- (UIImageView *)gifIV {
	if (!_gifIV) {
		_gifIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_Width/3, K_Width/3)];
		_gifIV.animationDuration = 2.0f;
		_gifIV.animationImages = [self getGifArray:nil];
		
	}return _gifIV;
}

- (UILabel *)countLabel {
	if (!_countLabel) {
		_countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, K_Width/2, 40.0f)];
		
		_countLabel.textColor = Color_Whiter;
		_countLabel.textAlignment = NSTextAlignmentCenter;
		_countLabel.font = [UIFont addHanSanSC:16.0f fontType:1];
		
		_countLabel.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.4];
		
		_countLabel.layer.cornerRadius = 4.0f;
		_countLabel.clipsToBounds = YES;
		
	}return _countLabel;
}

#pragma mark -
- (NSArray *)getGifArray:(NSString *_Nullable)gifUrlStr {
	//得到GIF图片的url
	if (![ToolUtil isEqualToNonNull:gifUrlStr ]) {
		gifUrlStr = [NSString stringWithFormat:@"gif_flower@%@x", Is_IPhoneX?@"3":@"2"];
	}
	NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:gifUrlStr withExtension:@"gif"];
	//将GIF图片转换成对应的图片源
	CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);
	//获取其中图片源个数，即由多少帧图片组成
	size_t frameCount = CGImageSourceGetCount(gifSource);
	//定义数组存储拆分出来的图片
	NSMutableArray *frames = [[NSMutableArray alloc] init];
	for (size_t i = 0; i < frameCount; i++) {
		//从GIF图片中取出源图片
		CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
		//将图片源转换成UIimageView能使用的图片源
		UIImage *imageName = [UIImage imageWithCGImage:imageRef];
		//将图片加入数组中
		[frames addObject:imageName];
		CGImageRelease(imageRef);
	}
	return [frames copy];
}

@end
