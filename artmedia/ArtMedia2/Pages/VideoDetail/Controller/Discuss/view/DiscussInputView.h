//
//  DiscussInputView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/7.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussInputView;
NS_ASSUME_NONNULL_BEGIN
@protocol DiscussInputDelegate <NSObject>

@optional
- (void)inputView:(DiscussInputView *)inputView didFinishInputWith:(NSString *)inputStr;

@end

@interface DiscussInputView : UIView

@property (weak, nonatomic) id <DiscussInputDelegate> delegate;

+ (instancetype _Nullable)shareInstance;

@property (nonatomic ,copy) NSString *placeholder;

- (void)show;
- (void)showWithKeybord:(BOOL)on;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
