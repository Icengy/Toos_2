//
//  SingleInputTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SingleInputTableCell;
@protocol SingleInputTableDelegate <NSObject>

@optional

/// 输入框内容改变
/// @param cell self
/// @param newInputText 新改变的输入内容
- (void)cell:(SingleInputTableCell *)cell textDidChanged:(NSString *_Nullable)newInputText;

/// 点击获取验证码
/// @param cell self
/// @param sender sender
- (void)cell:(SingleInputTableCell *)cell didSelectedCodeBtn:(id)sender;

@end

@interface SingleInputTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet AMButton *getCodeBtn;

@property (weak, nonatomic) id <SingleInputTableDelegate> delegate;

@property (nonatomic ,assign) UIRectCorner corners;
@property (nonatomic ,copy, nullable) NSString *titleText;
@property (nonatomic ,copy, nullable) NSString *placeholderText;
@property (nonatomic ,copy, nullable) NSString *inputText;
@property (nonatomic ,assign) BOOL hideCodeBtn;
@property (nonatomic ,assign) BOOL canEdit;
/// 验证码倒计时
@property (nonatomic ,assign) NSInteger timerCount;

@property (nonatomic ,assign) UIKeyboardType keyboardType;


@end

NS_ASSUME_NONNULL_END
