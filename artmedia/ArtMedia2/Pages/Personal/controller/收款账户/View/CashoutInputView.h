//
//  CashoutInputView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CashoutInputDelegate <NSObject>

@required
- (void)inputViewValueChanged:(NSString *_Nullable)inputText;

@end

@interface CashoutInputView : UIView

@property (weak, nonatomic) id <CashoutInputDelegate> delegate;
@property (nonatomic ,assign) NSInteger receiveType;
/// 总计可提现金额
@property (nonatomic, copy) NSString *availableCount;
/// 应提现金额（包含用户手动输入及固定数额提现）
@property (nonatomic, copy) NSString *shouldCount;

@end

NS_ASSUME_NONNULL_END
