//
//  MyInviterItemFillView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyInviterItemFillView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (nonatomic ,copy) void(^ endEditingBlock)(NSString *_Nullable inputCode);
@end

NS_ASSUME_NONNULL_END
